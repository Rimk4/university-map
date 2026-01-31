import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Campus Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ask AI: "Where is library?" or "I\'m hungry"',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Quick Questions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildQuickQuestion('Where is library?'),
                      _buildQuickQuestion('I\'m hungry'),
                      _buildQuickQuestion('Cheapest meal'),
                      _buildQuickQuestion('Bike parking'),
                      _buildQuickQuestion('PM2.5 today'),
                      _buildQuickQuestion('Bus schedule'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_searchHistory.isNotEmpty) ...[
                    const Text(
                      'Recent Searches',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ..._searchHistory.map((query) => ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(query),
                      onTap: () {
                        _searchController.text = query;
                        _performSearch();
                      },
                    )).toList(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickQuestion(String question) {
    return ActionChip(
      label: Text(question),
      onPressed: () {
        _searchController.text = question;
        _performSearch();
      },
    );
  }
  
  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        if (!_searchHistory.contains(query)) {
          _searchHistory.insert(0, query);
          if (_searchHistory.length > 5) {
            _searchHistory.removeLast();
          }
        }
      });
      
      // Показать результат поиска
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('AI Response'),
          content: Text(_getAIResponse(query)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  String _getAIResponse(String query) {
    if (query.toLowerCase().contains('hungry') || query.toLowerCase().contains('food')) {
      return 'The Student Cafeteria has Pad Thai for 60฿ (450 cal). Open until 8 PM.';
    } else if (query.toLowerCase().contains('library')) {
      return 'Main Library: Building A, 2nd floor. Open 8:00-20:00. 15 min walk from here.';
    } else if (query.toLowerCase().contains('cheap')) {
      return 'Cheapest meal: Fried Rice at Student Cafe - 50฿, 400 calories.';
    } else if (query.toLowerCase().contains('bike')) {
      return 'Nearest bike parking: Near Main Building entrance (10 bike slots).';
    } else if (query.toLowerCase().contains('pm2.5') || query.toLowerCase().contains('air')) {
      return 'Current PM2.5: 35.5 μg/m³ (Moderate). Safe for outdoor activities.';
    } else if (query.toLowerCase().contains('bus')) {
      return 'Campus bus runs every 15 min. Next bus in 7 min at Main Gate.';
    }
    
    return 'I found information about "$query". Check the campus map for details.';
  }
}
