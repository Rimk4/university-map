import 'package:flutter/material.dart';

class CampusMap extends StatelessWidget {
  const CampusMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Заглушка для карты
        Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map, size: 100, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  'Campus Map',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('Interactive map coming soon'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Map Features'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildFeatureItem('Real-time building locations'),
                            _buildFeatureItem('Route planning'),
                            _buildFeatureItem('Live comments'),
                            _buildFeatureItem('PM2.5 monitoring'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('View Map Features'),
                ),
              ],
            ),
          ),
        ),
        // Маркеры (демо)
        Positioned(
          top: 100,
          left: 100,
          child: _buildMapMarker('Library', Icons.library_books),
        ),
        Positioned(
          top: 200,
          left: 200,
          child: _buildMapMarker('Cafeteria', Icons.restaurant),
        ),
        Positioned(
          top: 300,
          left: 150,
          child: _buildMapMarker('Main Building', Icons.school),
        ),
      ],
    );
  }
  
  Widget _buildMapMarker(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
