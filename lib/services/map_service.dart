import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/campus_model.dart';
import '../models/route_model.dart';

class MapService {
  static const String _baseUrl = 'api.mapbox.com';
  static const String _directionsPath = '/directions/v5/mapbox/walking';

  Future<List<Building>> getBuildings() async {
    try {
      // Читаем данные из JSON файла
      final jsonString = await DefaultAssetBundle.of(
              // Используем глобальный контекст или передаем через параметры
              // В реальном приложении используйте BuildContext
              )
          .loadString('assets/data/campus_data.json');

      final jsonData = json.decode(jsonString);
      final buildingsData = jsonData['buildings'] as List;

      return buildingsData.map((buildingJson) {
        return Building.fromJson(buildingJson);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading buildings: $e');
      }
      return [];
    }
  }

  Future<CampusRoute> calculateRoute(
    CampusLocation start,
    CampusLocation end,
    String transportMode,
  ) async {
    try {
      // Формируем URL для Mapbox Directions API
      const accessToken = String.fromEnvironment(
        'MAPBOX_ACCESS_TOKEN',
        defaultValue: 'YOUR_MAPBOX_ACCESS_TOKEN',
      );

      final url = Uri.https(
        _baseUrl,
        _directionsPath,
        {
          'geometries': 'geojson',
          'access_token': accessToken,
          'overview': 'full',
          'steps': 'true',
          'annotations': 'distance,duration',
          'language': 'ru',
        },
      );

      final body = {
        'coordinates': [
          [start.lng, start.lat],
          [end.lng, end.lat],
        ],
        'profile': transportMode,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final routes = data['routes'] as List;

        if (routes.isNotEmpty) {
          final route = routes.first;
          final geometry = route['geometry'];
          final distance = route['distance'] as double;
          final duration = route['duration'] as double;

          // Преобразуем геометрию в список точек
          final List<CampusLocation> waypoints = [];
          if (geometry['type'] == 'LineString') {
            final coordinates = geometry['coordinates'] as List;
            for (final coord in coordinates) {
              waypoints.add(CampusLocation(
                lat: coord[1] as double,
                lng: coord[0] as double,
                name: 'Waypoint',
              ));
            }
          }

          // Рассчитываем сохраненный CO2
          final co2Saved = _calculateCo2Saved(transportMode, distance);

          return CampusRoute(
            id: 'route_${DateTime.now().millisecondsSinceEpoch}',
            name: 'Маршрут от ${start.name} до ${end.name}',
            waypoints: waypoints,
            distance: distance,
            estimatedTime: (duration / 60).round(), // в минуты
            transportMode: transportMode,
            co2Saved: co2Saved,
          );
        }
      }

      throw Exception('Не удалось построить маршрут');
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating route: $e');
      }
      // Возвращаем демо-маршрут в случае ошибки
      return CampusRoute(
        id: 'demo_route',
        name: 'Демо маршрут',
        waypoints: [start, end],
        distance: 500,
        estimatedTime: 10,
        transportMode: transportMode,
        co2Saved: transportMode == 'walking' ? 0 : 50,
      );
    }
  }

  double _calculateCo2Saved(String transportMode, double distance) {
    // Упрощенный расчет сохраненного CO2
    const double carCo2PerKm = 120; // грамм CO2 на км
    const double bikeCo2PerKm = 0;
    const double walkCo2PerKm = 0;

    final distanceKm = distance / 1000;

    switch (transportMode) {
      case 'walking':
        return carCo2PerKm * distanceKm - walkCo2PerKm;
      case 'cycling':
        return carCo2PerKm * distanceKm - bikeCo2PerKm;
      default:
        return 0;
    }
  }

  Future<List<dynamic>> searchPlaces(String query, LatLng location) async {
    // Поиск мест через Mapbox Geocoding API
    try {
      const accessToken = String.fromEnvironment(
        'MAPBOX_ACCESS_TOKEN',
        defaultValue: 'YOUR_MAPBOX_ACCESS_TOKEN',
      );

      final url = Uri.https(
        'api.mapbox.com',
        '/geocoding/v5/mapbox.places/$query.json',
        {
          'access_token': accessToken,
          'proximity': '${location.longitude},${location.latitude}',
          'language': 'ru',
          'types': 'address,poi',
          'limit': '10',
        },
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['features'] as List;
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error searching places: $e');
      }
      return [];
    }
  }
}
