import 'package:flutter/foundation.dart';
import 'campus_model.dart';

@immutable
class CampusRoute {
  final String id;
  final String name;
  final String? description;
  final List<CampusLocation> waypoints;
  final double distance; // в метрах
  final int estimatedTime; // в минутах
  final String transportMode;
  final double co2Saved; // сохраненный CO2 в граммах

  const CampusRoute({
    required this.id,
    required this.name,
    this.description,
    required this.waypoints,
    required this.distance,
    required this.estimatedTime,
    this.transportMode = 'walking',
    this.co2Saved = 0,
  });

  factory CampusRoute.fromJson(Map<String, dynamic> json) {
    final waypointsData = json['waypoints'] as List;
    return CampusRoute(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      waypoints:
          waypointsData.map((wp) => CampusLocation.fromJson(wp)).toList(),
      distance: (json['distance'] as num).toDouble(),
      estimatedTime: json['estimatedTime'] as int,
      transportMode: json['transportMode'] as String? ?? 'walking',
      co2Saved: (json['co2Saved'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'waypoints': waypoints.map((wp) => wp.toJson()).toList(),
      'distance': distance,
      'estimatedTime': estimatedTime,
      'transportMode': transportMode,
      'co2Saved': co2Saved,
    };
  }

  String get formattedDistance {
    if (distance < 1000) {
      return '${distance.round()} м';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} км';
    }
  }

  String get formattedCo2Saved {
    if (co2Saved < 1000) {
      return '${co2Saved.round()} г CO₂';
    } else {
      return '${(co2Saved / 1000).toStringAsFixed(1)} кг CO₂';
    }
  }
}
