import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/qr_model.dart';
import '../services/qr_service.dart';

class QRProvider with ChangeNotifier {
  final QRService _qrService = QRService();

  List<QRCode> _scannedCodes = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;
  bool _hasNewScan = false;

  List<QRCode> get scannedCodes => _scannedCodes;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;
  bool get hasNewScan => _hasNewScan;

  int get totalScans => _stats['total_scans'] as int? ?? 0;
  int get discountScans => _stats['discount_scans'] as int? ?? 0;
  int get stationScans => _stats['station_scans'] as int? ?? 0;

  Future<void> loadScanHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _scannedCodes = await _qrService.getScanHistory();
      _stats = await _qrService.getScanStats();

      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      if (kDebugMode) {
        print('Error loading scan history: $e');
      }
      _scannedCodes = [];
      _stats = {
        'total_scans': 0,
        'discount_scans': 0,
        'station_scans': 0,
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<QRCode> scanQR(String rawData) async {
    _isLoading = true;
    _hasNewScan = true;
    notifyListeners();

    try {
      // Декодируем QR-код
      final qrCode = await _qrService.decodeQR(rawData);

      // Проверяем валидность
      if (!_qrService.validateQR(qrCode)) {
        throw Exception('QR-код истек или недействителен');
      }

      // Проверяем дубликаты (не добавляем если уже сканировали сегодня)
      final today = DateTime.now();
      final isDuplicate = _scannedCodes.any((code) {
        return code.content == qrCode.content &&
            code.scannedAt?.day == today.day &&
            code.scannedAt?.month == today.month &&
            code.scannedAt?.year == today.year;
      });

      if (!isDuplicate) {
        // Добавляем в историю
        _scannedCodes.insert(0, qrCode);

        // Обновляем статистику
        _updateStats(qrCode.type);

        // Сохраняем в хранилище
        await _qrService.saveScannedCode(qrCode);
      }

      return qrCode;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      Future.delayed(const Duration(seconds: 2), () {
        _hasNewScan = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void _updateStats(QRType type) {
    _stats['total_scans'] = (stats['total_scans'] as int? ?? 0) + 1;
    _stats['last_scan'] = DateTime.now().toIso8601String();

    switch (type) {
      case QRType.discount:
        _stats['discount_scans'] = (stats['discount_scans'] as int? ?? 0) + 1;
        break;
      case QRType.station:
        _stats['station_scans'] = (stats['station_scans'] as int? ?? 0) + 1;
        break;
      case QRType.url:
        _stats['url_scans'] = (stats['url_scans'] as int? ?? 0) + 1;
        break;
      default:
        break;
    }
  }

  Future<void> saveScannedCode(QRCode code) async {
    await _qrService.saveScannedCode(code);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _qrService.clearHistory();
      _scannedCodes = [];
      _stats = {
        'total_scans': 0,
        'discount_scans': 0,
        'station_scans': 0,
        'url_scans': 0,
        'last_scan': null,
      };

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing history: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> getPartners() async {
    return await _qrService.getPartners();
  }

  QRCode? getLastScannedCode() {
    if (_scannedCodes.isEmpty) return null;
    return _scannedCodes.first;
  }

  List<QRCode> getTodayScans() {
    final today = DateTime.now();
    return _scannedCodes.where((code) {
      return code.scannedAt?.day == today.day &&
          code.scannedAt?.month == today.month &&
          code.scannedAt?.year == today.year;
    }).toList();
  }

  List<QRCode> getDiscountCodes() {
    return _scannedCodes.where((code) => code.type == QRType.discount).toList();
  }

  List<QRCode> getStationCodes() {
    return _scannedCodes.where((code) => code.type == QRType.station).toList();
  }

  bool hasActiveDiscounts() {
    final now = DateTime.now();
    return _scannedCodes.any((code) {
      return code.type == QRType.discount &&
          (code.expiryDate == null || now.isBefore(code.expiryDate!));
    });
  }

  Map<String, int> getWeeklyStats() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weeklyScans = _scannedCodes.where((code) {
      return code.scannedAt?.isAfter(weekAgo) ?? false;
    }).length;

    final weeklyDiscounts = _scannedCodes.where((code) {
      return code.type == QRType.discount &&
          (code.scannedAt?.isAfter(weekAgo) ?? false);
    }).length;

    return {
      'scans': weeklyScans,
      'discounts': weeklyDiscounts,
    };
  }
}
