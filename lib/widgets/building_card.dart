import 'package:flutter/material.dart';

class BuildingCard extends StatelessWidget {
  final String name;
  final String description;
  final String distance;
  final VoidCallback onTap;
  
  const BuildingCard({
    super.key,
    required this.name,
    required this.description,
    required this.distance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_city, color: Colors.blue),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text('Distance: $distance'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
