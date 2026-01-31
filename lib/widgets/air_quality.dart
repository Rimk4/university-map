import 'package:flutter/material.dart';

class AirQuality extends StatelessWidget {
  const AirQuality({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.air, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Air Quality (PM2.5)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Current: 35.5 μg/m³',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            const Text('Level: Moderate', style: TextStyle(color: Colors.orange)),
            const SizedBox(height: 4),
            const Text('Safe for outdoor activities'),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: 0.35,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Good', style: TextStyle(fontSize: 12)),
                Text('Moderate', style: TextStyle(fontSize: 12)),
                Text('Unhealthy', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
