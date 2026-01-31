import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.bangkok-university.edu';
  
  Future<Map<String, dynamic>> getAirQuality() async {
    // Демо данные качества воздуха
    return {
      'pm25': 35.5,
      'pm10': 45.2,
      'aqi': 85,
      'level': 'Moderate',
      'advice': 'Normal outdoor activities',
    };
  }
  
  Future<List<Map<String, dynamic>>> getLiveComments() async {
    // Демо живые комментарии
    return [
      {'user': 'Student1', 'message': 'Long queue at library', 'time': '10 min ago'},
      {'user': 'Student2', 'message': 'Elevator in Main Bldg is busy', 'time': '5 min ago'},
    ];
  }
  
  Future<List<Map<String, dynamic>>> getFoodOptions() async {
    // Демо данные еды
    return [
      {'name': 'Pad Thai', 'place': 'Main Cafeteria', 'price': 60, 'calories': 450},
      {'name': 'Fried Rice', 'place': 'Student Cafe', 'price': 50, 'calories': 400},
      {'name': 'Noodle Soup', 'place': 'Food Court', 'price': 45, 'calories': 350},
    ];
  }
}
