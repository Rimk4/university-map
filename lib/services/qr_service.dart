import '../models/qr_model.dart';

class QRService {
  Future<QRCode> decodeQR(String data) async {
    // Демо декодирование
    return QRCode(
      id: data,
      name: 'QR Code',
      description: 'Scanned successfully',
      discount: 10,
      isStation: data.contains('station'),
    );
  }
  
  Future<void> saveScannedCode(QRCode code) async {
    // Сохранение в локальное хранилище
    print('Saved QR code: ${code.name}');
  }
}
