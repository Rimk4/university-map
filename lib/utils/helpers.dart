import 'package:flutter/material.dart';

class Helpers {
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toInt()} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
  
  static String formatTime(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '$hours h ${remainingMinutes > 0 ? '$remainingMinutes min' : ''}';
  }
  
  static Color getAirQualityColor(double pm25) {
    if (pm25 <= 25) return Colors.green;
    if (pm25 <= 50) return Colors.yellow;
    if (pm25 <= 100) return Colors.orange;
    return Colors.red;
  }
  
  static String getAirQualityLevel(double pm25) {
    if (pm25 <= 25) return 'Good';
    if (pm25 <= 50) return 'Moderate';
    if (pm25 <= 100) return 'Unhealthy';
    return 'Hazardous';
  }
}
