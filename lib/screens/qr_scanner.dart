import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../providers/qr_provider.dart';
import '../providers/activity_provider.dart';
import '../models/qr_model.dart';
import '../widgets/qr_history.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    autoStart: true,
  );

  bool _isScanning = true;
  bool _hasPermission = true;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    _initializeNotifications();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _checkCameraPermission() async {
    // В реальном приложении используйте permission_handler
    setState(() => _hasPermission = true);
  }

  Future<void> _initializeNotifications() async {
    // Инициализация уведомлений
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: _switchCamera,
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistory(context),
            color: Colors.white,
          ),
        ],
      ),
      body: _buildScannerBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildScannerBody() {
    if (!_hasPermission) {
      return _buildPermissionDenied();
    }

    return Stack(
      children: [
        MobileScanner(
          controller: cameraController,
          onDetect: (capture) {
            final barcodes = capture.barcodes;
            if (barcodes.isNotEmpty && _isScanning) {
              _handleQRScan(barcodes.first.rawValue);
            }
          },
        ),

        // Сканирующая рамка
        _buildScannerOverlay(),

        // Инструкция
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Наведите камеру на QR код. Сканирование происходит автоматически.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.green,
            width: 3,
          ),
        ),
        child: Stack(
          children: [
            // Анимация сканирования
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.green.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Углы рамки
            Positioned(
              top: 0,
              left: 0,
              child: _buildCorner(Alignment.topLeft),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _buildCorner(Alignment.topRight),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildCorner(Alignment.bottomLeft),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _buildCorner(Alignment.bottomRight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Container(
      width: 40,
      height: 40,
      alignment: alignment,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            left: const BorderSide(
              color: Colors.green,
              width: 4,
            ),
            top: const BorderSide(
              color: Colors.green,
              width: 4,
            ),
            right: alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? BorderSide.none
                : const BorderSide(
                    color: Colors.green,
                    width: 4,
                  ),
            bottom: alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? BorderSide.none
                : const BorderSide(
                    color: Colors.green,
                    width: 4,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_off,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Требуется доступ к камере',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Для сканирования QR-кодов необходимо разрешение на использование камеры.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _requestPermission,
              child: const Text('Разрешить доступ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.photo_library,
                  label: 'Галерея',
                  onPressed: _scanFromGallery,
                ),
                _buildActionButton(
                  icon: Icons.flashlight_on,
                  label: _isFlashOn ? 'Выкл' : 'Вкл',
                  onPressed: _toggleFlash,
                ),
                _buildActionButton(
                  icon: Icons.history,
                  label: 'История',
                  onPressed: () => _showHistory(context),
                ),
                _buildActionButton(
                  icon: Icons.qr_code,
                  label: 'Мои QR',
                  onPressed: _showMyQRCodes,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isScanning ? _pauseScanning : _resumeScanning,
              icon: Icon(_isScanning ? Icons.pause : Icons.play_arrow),
              label: Text(_isScanning ? 'Пауза' : 'Сканировать'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: _isScanning ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  void _handleQRScan(String? rawValue) async {
    if (rawValue == null || !_isScanning) return;

    setState(() => _isScanning = false);

    final qrProvider = context.read<QRProvider>();
    final activityProvider = context.read<ActivityProvider>();

    try {
      // Обрабатываем QR-код
      final qrCode = await qrProvider.scanQR(rawValue);

      // Сохраняем в историю
      await qrProvider.saveScannedCode(qrCode);

      // Показываем результат
      await _showScanResult(context, qrCode);

      // Обработка станций
      if (qrCode.type == QRType.station) {
        activityProvider.markStationComplete(qrCode.stationId!);
      }

      // Показываем уведомление
      _showNotification(qrCode);
    } catch (e) {
      _showErrorDialog('Ошибка при сканировании: $e');
    } finally {
      // Возобновляем сканирование через 2 секунды
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isScanning = true);
        }
      });
    }
  }

  Future<void> _showScanResult(BuildContext context, QRCode qrCode) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) => QRResultSheet(qrCode: qrCode),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isScanning = true);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      cameraController.toggleTorch();
    });
  }

  void _switchCamera() {
    cameraController.switchCamera();
  }

  void _pauseScanning() {
    setState(() => _isScanning = false);
  }

  void _resumeScanning() {
    setState(() => _isScanning = true);
  }

  void _scanFromGallery() async {
    setState(() => _isScanning = false);

    // В реальном приложении используйте image_picker
    _showErrorDialog('Функционал сканирования из галереи временно недоступен');

    setState(() => _isScanning = true);
  }

  void _showHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('История сканирований')),
          body: const QRHistoryScreen(),
        ),
      ),
    );
  }

  void _showMyQRCodes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Мои QR-коды'),
        content:
            const Text('Здесь будут отображаться ваши персональные QR-коды'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _requestPermission() {
    // В реальном приложении используйте permission_handler
    setState(() => _hasPermission = true);
  }

  void _showNotification(QRCode qrCode) {
    // В реальном приложении используйте flutter_local_notifications
    if (qrCode.type == QRType.discount && qrCode.discountValue > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Скидка ${qrCode.discountValue}% активирована!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

class QRResultSheet extends StatelessWidget {
  final QRCode qrCode;

  const QRResultSheet({super.key, required this.qrCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getBackgroundColor(qrCode.type),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Заголовок
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIcon(qrCode.type),
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      qrCode.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _getSubtitle(qrCode.type),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Содержимое
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (qrCode.description.isNotEmpty)
                  Text(
                    qrCode.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                if (qrCode.type == QRType.discount && qrCode.discountValue > 0)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_offer, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Скидка ${qrCode.discountValue}%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Срок действия: ${_formatDate(qrCode.expiryDate)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                if (qrCode.type == QRType.station)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 8),
                            const Text(
                              'Станция отмечена!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '+${qrCode.xpReward} XP',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (qrCode.type == QRType.url)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _launchURL(qrCode.url!),
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Открыть ссылку'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                if (qrCode.type == QRType.text)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _copyToClipboard(context, qrCode.content),
                          icon: const Icon(Icons.copy),
                          label: const Text('Копировать текст'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                  ),
                  child: const Text('Закрыть'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _shareResult(context, qrCode),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(0, 50),
                  ),
                  child: const Text('Поделиться'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Color _getBackgroundColor(QRType type) {
    switch (type) {
      case QRType.discount:
        return const Color(0xFF4CAF50); // Зеленый
      case QRType.station:
        return const Color(0xFF2196F3); // Синий
      case QRType.url:
        return const Color(0xFF9C27B0); // Фиолетовый
      case QRType.text:
        return const Color(0xFFFF9800); // Оранжевый
      case QRType.contact:
        return const Color(0xFF607D8B); // Серый
      default:
        return const Color(0xFF2196F3);
    }
  }

  IconData _getIcon(QRType type) {
    switch (type) {
      case QRType.discount:
        return Icons.local_offer;
      case QRType.station:
        return Icons.location_on;
      case QRType.url:
        return Icons.link;
      case QRType.text:
        return Icons.text_snippet;
      case QRType.contact:
        return Icons.person;
      default:
        return Icons.qr_code;
    }
  }

  String _getSubtitle(QRType type) {
    switch (type) {
      case QRType.discount:
        return 'QR-код скидки';
      case QRType.station:
        return 'Станция кампуса';
      case QRType.url:
        return 'Веб-ссылка';
      case QRType.text:
        return 'Текстовый QR-код';
      case QRType.contact:
        return 'Контактная информация';
      default:
        return 'QR-код';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Не ограничено';
    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  void _launchURL(String url) async {
    // В реальном приложении используйте url_launcher
    print('Launching URL: $url');
  }

  void _copyToClipboard(BuildContext context, String text) {
    // В реальном приложении используйте clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Текст скопирован')),
    );
  }

  void _shareResult(BuildContext context, QRCode qrCode) {
    // В реальном приложении используйте share_plus
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Функция поделиться')),
    );
  }
}
