import 'package:flutter/material.dart';
import '../widgets/campus_map.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: const Icon(Icons.route),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Route Planning'),
                  content: const Text('Route planning feature coming soon'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: const CampusMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Центрировать на текущем местоположении
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
