import 'package:flutter/material.dart';

class RoutePlanner extends StatelessWidget {
  const RoutePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Route Planner',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'From',
                hintText: 'Current location',
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'To',
                hintText: 'Enter destination',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Transport Options',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTransportOption(Icons.directions_walk, 'Walking', '10 min', '0g CO₂'),
            _buildTransportOption(Icons.directions_bike, 'Biking', '5 min', '50g saved'),
            _buildTransportOption(Icons.electric_scooter, 'Scooter', '4 min', '25g saved'),
            _buildTransportOption(Icons.directions_bus, 'Campus Bus', '8 min', '100g saved'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Plan Route'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransportOption(IconData icon, String mode, String time, String co2) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon),
        title: Text(mode),
        subtitle: Text('Time: $time'),
        trailing: Text(co2, style: const TextStyle(color: Colors.green)),
        onTap: () {},
      ),
    );
  }
}
