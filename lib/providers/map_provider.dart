import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Временные модели
class CampusLocation {
  final double lat;
  final double lng;
  final String name;
  final String? address;
  
  CampusLocation({
    required this.lat,
    required this.lng,
    required this.name,
    this.address,
  });
}

class Building {
  final String id;
  final String name;
  final String description;
  final CampusLocation location;
  
  Building({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
  });
}

class MapProvider with ChangeNotifier {
  List<Building> _buildings = [];
  bool _isLoading = false;
  
  List<Building> get buildings => _buildings;
  bool get isLoading => _isLoading;
  
  Future<void> loadCampusData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Демо данные
      _buildings = [
        Building(
          id: '1',
          name: 'Main Building',
          description: 'Central administrative building',
          location: CampusLocation(
            lat: 13.736717,
            lng: 100.523186,
            name: 'Main Building',
          ),
        ),
        Building(
          id: '2',
          name: 'Science Building',
          description: 'Faculties of Science and Engineering',
          location: CampusLocation(
            lat: 13.736717 + 0.001,
            lng: 100.523186 + 0.001,
            name: 'Science Building',
          ),
        ),
      ];
      
      await Future.delayed(const Duration(seconds: 1)); // Имитация загрузки
      
    } catch (e) {
      if (kDebugMode) {
        print('Error loading campus data: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Упрощенный расчет расстояния
  double _calculateDistance(CampusLocation a, CampusLocation b) {
    // Простая формула для приблизительного расчета
    final latDiff = (a.lat - b.lat).abs();
    final lngDiff = (a.lng - b.lng).abs();
    
    // Приблизительно 111 км на градус широты
    // и 111 * cos(широта) км на градус долготы
    final distanceKm = sqrt(pow(latDiff * 111, 2) + pow(lngDiff * 111 * cos(a.lat * pi / 180), 2));
    
    return distanceKm * 1000; // Возвращаем в метрах
  }
}
