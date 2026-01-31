import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freshman Activities'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Campus Exploration Progress',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: provider.completionPercentage / 100,
                    minHeight: 20,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 8),
                  Text('${provider.completionPercentage.toStringAsFixed(1)}% Complete'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('${provider.distanceWalked.toStringAsFixed(1)} km', 'Distance'),
                      _buildStatItem('${provider.caloriesBurned} cal', 'Calories'),
                      _buildStatItem('${provider.stations.length} Stations', 'Total'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'QR Stations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...provider.stations.map((station) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                station.isCompleted ? Icons.check_circle : Icons.qr_code,
                color: station.isCompleted ? Colors.green : Colors.blue,
              ),
              title: Text(station.name),
              subtitle: Text('Location: ${station.location.name}'),
              trailing: station.isCompleted
                  ? const Icon(Icons.check, color: Colors.green)
                  : const Icon(Icons.arrow_forward),
            ),
          )).toList(),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
