import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/qr_model.dart';

class QRService {
  static const String _prefsKey = 'scanned_qr_history';
  static const String _prefsStatsKey = 'qr_scan_stats';

  // Декодирование QR-кода
  Future<QRCode> decodeQR(String rawData) async {
    try {
      // Парсинг JSON если это JSON строка
      if (rawData.startsWith('{') && rawData.endsWith('}')) {
        return _parseJSONQR(rawData);
      }

      // Парсинг URL если это ссылка
      if (rawData.startsWith('http://') || rawData.startsWith('https://')) {
        return _parseURLQR(rawData);
      }

      // Проверка на станции (формат: station:station_id)
      if (rawData.startsWith('station:')) {
        return _parseStationQR(rawData);
      }

      // Проверка на скидки (формат: discount:discount_id:value)
      if (rawData.startsWith('discount:')) {
        return _parseDiscountQR(rawData);
      }

      // Проверка на контакты (формат: contact:data)
      if (rawData.startsWith('contact:')) {
        return _parseContactQR(rawData);
      }

      // По умолчанию - текстовый QR-код
      return _parseTextQR(rawData);
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding QR: $e');
      }
      return QRCode.error(rawData);
    }
  }

  QRCode _parseJSONQR(String jsonString) {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;

      final typeStr = data['type'] as String? ?? 'text';
      final type = QRType.values.firstWhere(
        (t) => t.toString().split('.').last == typeStr,
        orElse: () => QRType.text,
      );

      return QRCode(
        id: 'qr_${DateTime.now().millisecondsSinceEpoch}',
        name: data['name'] as String? ?? 'QR Code',
        description: data['description'] as String? ?? '',
        content: jsonString,
        type: type,
        discountValue: (data['discount'] as num?)?.toDouble() ?? 0.0,
        expiryDate: data['expiry'] != null
            ? DateTime.parse(data['expiry'] as String)
            : null,
        stationId: data['stationId'] as String?,
        xpReward: data['xp'] as int? ?? 10,
        url: data['url'] as String?,
        businessName: data['business'] as String?,
        scannedAt: DateTime.now(),
      );
    } catch (e) {
      return QRCode.text(
        id: 'qr_${DateTime.now().millisecondsSinceEpoch}',
        content: jsonString,
      );
    }
  }

  QRCode _parseURLQR(String url) {
    return QRCode.url(
      id: 'url_${DateTime.now().millisecondsSinceEpoch}',
      url: url,
      description: 'Веб-страница',
      scannedAt: DateTime.now(),
    );
  }

  QRCode _parseStationQR(String data) {
    final parts = data.split(':');
    final stationId = parts.length > 1 ? parts[1] : 'unknown';

    return QRCode.station(
      id: 'station_$stationId',
      stationId: stationId,
      name: 'Станция кампуса',
      description: 'Отсканируйте эту станцию для отметки посещения',
      xpReward: 15,
      scannedAt: DateTime.now(),
    );
  }

  QRCode _parseDiscountQR(String data) {
    final parts = data.split(':');
    final discountId = parts.length > 1 ? parts[1] : 'unknown';
    final discountValue =
        parts.length > 2 ? double.tryParse(parts[2]) ?? 10.0 : 10.0;

    return QRCode.discount(
      id: 'discount_$discountId',
      name: 'Скидка $discountValue%',
      description: 'Покажите этот QR-код на кассе для получения скидки',
      discountValue: discountValue,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      businessName: 'Партнер кампуса',
      scannedAt: DateTime.now(),
    );
  }

  QRCode _parseContactQR(String data) {
    return QRCode.contact(
      id: 'contact_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Контакт',
      description: 'Контактная информация',
      content: data,
      scannedAt: DateTime.now(),
    );
  }

  QRCode _parseTextQR(String text) {
    return QRCode.text(
      id: 'text_${DateTime.now().millisecondsSinceEpoch}',
      content: text,
      scannedAt: DateTime.now(),
    );
  }

  // Сохранение отсканированного кода
  Future<void> saveScannedCode(QRCode code) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Загружаем историю
      final historyJson = prefs.getString(_prefsKey);
      List<dynamic> history = [];

      if (historyJson != null) {
        history = json.decode(historyJson) as List<dynamic>;
      }

      // Добавляем новый код
      history.insert(0, code.toJson());

      // Ограничиваем историю 100 записями
      if (history.length > 100) {
        history = history.sublist(0, 100);
      }

      // Сохраняем обновленную историю
      await prefs.setString(_prefsKey, json.encode(history));

      // Обновляем статистику
      await _updateStats(prefs, code.type);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving QR code: $e');
      }
    }
  }

  Future<void> _updateStats(SharedPreferences prefs, QRType type) async {
    final statsJson = prefs.getString(_prefsStatsKey);
    Map<String, dynamic> stats = {
      'total_scans': 0,
      'discount_scans': 0,
      'station_scans': 0,
      'url_scans': 0,
      'last_scan': DateTime.now().toIso8601String(),
    };

    if (statsJson != null) {
      stats = Map<String, dynamic>.from(json.decode(statsJson));
    }

    // Обновляем счетчики
    stats['total_scans'] = (stats['total_scans'] as int? ?? 0) + 1;

    switch (type) {
      case QRType.discount:
        stats['discount_scans'] = (stats['discount_scans'] as int? ?? 0) + 1;
        break;
      case QRType.station:
        stats['station_scans'] = (stats['station_scans'] as int? ?? 0) + 1;
        break;
      case QRType.url:
        stats['url_scans'] = (stats['url_scans'] as int? ?? 0) + 1;
        break;
      default:
        break;
    }

    stats['last_scan'] = DateTime.now().toIso8601String();

    await prefs.setString(_prefsStatsKey, json.encode(stats));
  }

  // Получение истории сканирований
  Future<List<QRCode>> getScanHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_prefsKey);

      if (historyJson == null) return [];

      final historyList = json.decode(historyJson) as List<dynamic>;

      return historyList.map((item) {
        return QRCode.fromJson(Map<String, dynamic>.from(item));
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading scan history: $e');
      }
      return [];
    }
  }

  // Получение статистики
  Future<Map<String, dynamic>> getScanStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString(_prefsStatsKey);

      if (statsJson == null) {
        return {
          'total_scans': 0,
          'discount_scans': 0,
          'station_scans': 0,
          'url_scans': 0,
          'last_scan': null,
        };
      }

      return Map<String, dynamic>.from(json.decode(statsJson));
    } catch (e) {
      if (kDebugMode) {
        print('Error loading scan stats: $e');
      }
      return {
        'total_scans': 0,
        'discount_scans': 0,
        'station_scans': 0,
        'url_scans': 0,
        'last_scan': null,
      };
    }
  }

  // Очистка истории
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
      await prefs.remove(_prefsStatsKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing history: $e');
      }
    }
  }

  // Генерация QR-кода для станции
  QRCode generateStationQR(String stationId, String stationName) {
    return QRCode.station(
      id: 'generated_station_$stationId',
      stationId: stationId,
      name: stationName,
      description: 'Станция: $stationName',
      xpReward: 15,
      scannedAt: null,
    );
  }

  // Валидация QR-кода
  bool validateQR(QRCode code) {
    if (code.type == QRType.discount && code.expiryDate != null) {
      return DateTime.now().isBefore(code.expiryDate!);
    }
    return true;
  }

  // Получение списка партнеров
  Future<List<Map<String, dynamic>>> getPartners() async {
    // Демо данные партнеров
    return [
      {
        'id': 'partner_1',
        'name': 'Campus Cafe',
        'description': 'Кофейня в главном корпусе',
        'discount': 15,
        'qrData': 'discount:campus_cafe:15',
      },
      {
        'id': 'partner_2',
        'name': 'Bookstore',
        'description': 'Университетский книжный магазин',
        'discount': 20,
        'qrData': 'discount:bookstore:20',
      },
      {
        'id': 'partner_3',
        'name': 'Gym',
        'description': 'Спортивный комплекс',
        'discount': 10,
        'qrData': 'discount:gym:10',
      },
    ];
  }
}
