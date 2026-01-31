class CampusLocation {
  final double lat;
  final double lng;
  final String name;
  
  CampusLocation({
    required this.lat,
    required this.lng,
    required this.name,
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

class CampusMarker {
  final String id;
  final String title;
  final String description;
  final CampusLocation location;
  final String type;
  
  CampusMarker({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
  });
}

class CampusRoute {
  final String id;
  final String name;
  final List<CampusLocation> waypoints;
  final double distance;
  final int estimatedTime;
  final String transportMode;
  final double co2Saved;
  
  CampusRoute({
    required this.id,
    required this.name,
    required this.waypoints,
    required this.distance,
    required this.estimatedTime,
    required this.transportMode,
    required this.co2Saved,
  });
}
