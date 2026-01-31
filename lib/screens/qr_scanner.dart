import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../providers/qr_provider.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanning = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isScanning
                  ? const Center(child: CircularProgressIndicator())
                  : const Icon(Icons.qr_code_scanner, size: 100, color: Colors.blue),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _simulateScan,
              child: const Text('Simulate QR Scan'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Map'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _simulateScan() async {
    setState(() => _isScanning = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    final qrProvider = context.read<QRProvider>();
    final activityProvider = context.read<ActivityProvider>();
    
    // Демо сканирование
    final code = await qrProvider.scanQR('station_1');
    
    setState(() => _isScanning = false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(code.name),
        content: Text(code.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    
    if (code.isStation) {
      activityProvider.markStationComplete(code.id);
    }
  }
}
