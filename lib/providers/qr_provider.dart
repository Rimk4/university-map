import 'package:flutter/material.dart';
import '../models/qr_model.dart';

class QRProvider with ChangeNotifier {
  List<QRCode> _availableCodes = [];
  
  List<QRCode> get availableCodes => _availableCodes;
  
  Future<void> loadQRCodes() async {
    // Демо данные
    _availableCodes = [
      QRCode(
        id: 'discount_1',
        name: 'Cafeteria Discount',
        description: '15% off at main cafeteria',
        discount: 15,
        isStation: false,
      ),
      QRCode(
        id: 'station_1',
        name: 'Welcome Station',
        description: 'First station for freshmen',
        discount: 0,
        isStation: true,
      ),
    ];
    
    notifyListeners();
  }
  
  Future<QRCode?> scanQR(String data) async {
    // Имитация сканирования
    await Future.delayed(const Duration(seconds: 1));
    
    final code = _availableCodes.firstWhere(
      (c) => c.id == data,
      orElse: () => QRCode(
        id: 'unknown',
        name: 'Unknown QR',
        description: 'This QR code is not recognized',
        discount: 0,
        isStation: false,
      ),
    );
    
    return code;
  }
}
