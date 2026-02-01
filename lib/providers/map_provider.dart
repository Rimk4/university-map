import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/campus_model.dart';
import '../services/map_service.dart';

class MapProvider with ChangeNotifier {
  List<Building> _buildings = [];
  List<CampusRoute> _routes = [];
  bool _isLoading = false;
  Building? _selectedBuilding;
  CampusRoute? _activeRoute;
  LatLngBounds? _visibleRegion;
  
  final MapService _mapService = MapService();
  
  List<Building> get buildings => _buildings;
  List<CampusRoute> get routes => _routes;
  bool get isLoading => _isLoading;
  Building? get selectedBuilding => _selectedBuilding;
  CampusRoute? get activeRoute => _activeRoute;
  LatLngBounds? get visibleRegion => _visibleRegion;
  
  Future<void> loadCampusData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Загружаем здания из JSON файла
      final jsonString = await rootBundle.loadString('assets/data/campus_data.json');
      final jsonData = json.decode(jsonString);
      
      // Парсим здания
      final buildingsData = jsonData['buildings'] as List;
      _buildings = buildingsData.map((buildingJson) {
        return Building.fromJson(buildingJson);
      }).toList();
      
      // Парсим маршруты
      final routesData = jsonData['routes'] as List? ?? [];
      _routes = routesData.map((routeJson) {
        return CampusRoute.fromJson(routeJson);
      }).toList();
      
      await Future.delayed(const Duration(milliseconds: 500));
      
    } catch (e) {
      if (kDebugMode) {
        print('Error loading campus data: $e');
      }
      
      // Запасной вариант через MapService
      _buildings = await _mapService.getBuildings();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void selectBuilding(Building building) {
    _selectedBuilding = building;
    notifyListeners();
  }
  
  void clearSelection() {
    _selectedBuilding = null;
    notifyListeners();
  }
  
  void setActiveRoute(CampusRoute route) {
    _activeRoute = route;
    notifyListeners();
  }
  
  void clearRoute() {
    _activeRoute = null;
    notifyListeners();
  }
  
  void updateVisibleRegion(LatLngBounds bounds) {
    _visibleRegion = bounds;
    notifyListeners();
  }
  
  Future<List<Building>> getBuildingsInRegion(LatLngBounds bounds) async {
    return _buildings.where((building) {
      final lat = building.location.lat;
      final lng = building.location.lng;
      return lat >= bounds.southwest!.latitude &&
             lat <= bounds.northeast!.latitude &&
             lng >= bounds.southwest!.longitude &&
             lng <= bounds.northeast!.longitude;
    }).toList();
  }
  
  Future<CampusRoute> calculateRoute(
    CampusLocation start,
    CampusLocation end,
    String transportMode,
  ) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final route = await _mapService.calculateRoute(
        start,
        end,
        transportMode,
      );
      
      _routes.add(route);
      _activeRoute = route;
      
      return route;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  List<Building> searchBuildings(String query) {
    if (query.isEmpty) return [];
    
    final lowercaseQuery = query.toLowerCase();
    return _buildings.where((building) {
      return building.name.toLowerCase().contains(lowercaseQuery) ||
             building.description.toLowerCase().contains(lowercaseQuery) ||
             (building.location.address?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }
  
  // Добавляем поддержку LatLngBounds из mapbox_gl
  class LatLngBounds {
    final LatLng? northeast;
    final LatLng? southwest;
    
    LatLngBounds({this.northeast, this.southwest});
  }
  
  class LatLng {
    final double latitude;
    final double longitude;
    
    LatLng(this.latitude, this.longitude);
  }
}
