class LocationService {
  Future<Map<String, double>> getCurrentLocation() async {
    // Демо местоположение
    return {'lat': 13.736717, 'lng': 100.523186};
  }
  
  Future<double> calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) async {
    // Простой расчет расстояния
    final latDiff = lat2 - lat1;
    final lngDiff = lng2 - lng1;
    return (latDiff * latDiff + lngDiff * lngDiff).abs() * 111000; // meters
  }
}
