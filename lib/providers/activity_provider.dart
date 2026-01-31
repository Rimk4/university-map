import 'package:flutter/material.dart';

class ActivityProvider with ChangeNotifier {
  List<Map<String, dynamic>> _stations = []; // Используем Map вместо QRStation
  double _distanceWalked = 0.0;
  int _caloriesBurned = 0;
  double _completionPercentage = 0.0;
  
  List<Map<String, dynamic>> get stations => _stations;
  double get distanceWalked => _distanceWalked;
  int get caloriesBurned => _caloriesBurned;
  double get completionPercentage => _completionPercentage;
  
  Future<void> loadStations() async {
    // Демо данные
    _stations = [
      {
        'id': 'station_1',
        'name': 'Main Entrance',
        'location': {'lat': 13.736717, 'lng': 100.523186, 'name': 'Main Entrance'},
        'isCompleted': true,
      },
      {
        'id': 'station_2',
        'name': 'Library',
        'location': {'lat': 13.736817, 'lng': 100.523286, 'name': 'Library'},
        'isCompleted': true,
      },
      {
        'id': 'station_3',
        'name': 'Science Building',
        'location': {'lat': 13.737717, 'lng': 100.524186, 'name': 'Science Building'},
        'isCompleted': false,
      },
    ];
    
    _completionPercentage = (_stations.where((s) => s['isCompleted'] == true).length / _stations.length) * 100;
    
    notifyListeners();
  }
  
  void markStationComplete(String stationId) {
    final index = _stations.indexWhere((s) => s['id'] == stationId);
    if (index != -1) {
      _stations[index]['isCompleted'] = true;
      _completionPercentage = (_stations.where((s) => s['isCompleted'] == true).length / _stations.length) * 100;
      notifyListeners();
    }
  }
  
  void updateActivity(double distance) {
    _distanceWalked += distance;
    _caloriesBurned += (distance * 70).toInt(); // Примерный расчет
    notifyListeners();
  }
}
