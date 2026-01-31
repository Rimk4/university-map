import 'package:flutter/material.dart';

class LiveComments extends StatelessWidget {
  const LiveComments({super.key});

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
                Icon(Icons.chat, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Live Campus Comments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildComment('Student1', 'Long queue at library today', '10 min ago'),
            _buildComment('Student2', 'Elevator in Main Bldg is busy', '5 min ago'),
            _buildComment('Student3', 'Great food at new cafeteria!', '15 min ago'),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Add your comment...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildComment(String user, String message, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          Text(message),
          const Divider(height: 16),
        ],
      ),
    );
  }
}
