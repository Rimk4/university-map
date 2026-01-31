import '../models/campus_model.dart';
import '../models/route_model.dart';

class MapService {
  Future<List<Building>> getBuildings() async {
    // Демо данные
    return [
      Building(
        id: '1',
        name: 'Main Building',
        description: 'Central building',
        location: CampusLocation(lat: 13.736717, lng: 100.523186, name: 'Main Building'),
      ),
    ];
  }
  
  Future<CampusRoute> calculateRoute(
    CampusLocation start,
    CampusLocation end,
    String transportMode,
  ) async {
    // Демо расчет маршрута
    return CampusRoute(
      id: 'route_1',
      name: 'Route to ${end.name}',
      waypoints: [start, end],
      distance: 500, // meters
      estimatedTime: 10, // minutes
      transportMode: transportMode,
      co2Saved: transportMode == 'walking' ? 0 : 50,
    );
  }
}
