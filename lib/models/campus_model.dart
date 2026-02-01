import 'package:flutter/foundation.dart';

@immutable
class CampusLocation {
  final double lat;
  final double lng;
  final String name;
  final String? address;

  const CampusLocation({
    required this.lat,
    required this.lng,
    required this.name,
    this.address,
  });

  factory CampusLocation.fromJson(Map<String, dynamic> json) {
    return CampusLocation(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
      name: json['name'] as String,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'name': name,
      'address': address,
    };
  }
}

@immutable
class Building {
  final String id;
  final String name;
  final String description;
  final CampusLocation location;
  final String type;
  final int floors;
  final int yearBuilt;
  final String icon;

  const Building({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.type = 'academic',
    this.floors = 1,
    this.yearBuilt = 2000,
    this.icon = 'building',
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      location: CampusLocation.fromJson(json['location']),
      type: json['type'] as String? ?? 'academic',
      floors: json['floors'] as int? ?? 1,
      yearBuilt: json['yearBuilt'] as int? ?? 2000,
      icon: json['icon'] as String? ?? 'building',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location.toJson(),
      'type': type,
      'floors': floors,
      'yearBuilt': yearBuilt,
      'icon': icon,
    };
  }
}
