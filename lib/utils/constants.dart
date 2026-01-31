import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E3A8A); // Bangkok University blue
  static const Color secondary = Color(0xFF3B82F6);
  static const Color accent = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color light = Color(0xFFF8FAFC);
  static const Color dark = Color(0xFF1E293B);
  
  // PM2.5 уровни
  static const Color pmGood = Color(0xFF10B981);
  static const Color pmModerate = Color(0xFFF59E0B);
  static const Color pmUnhealthy = Color(0xFFEF4444);
  static const Color pmHazardous = Color(0xFF7C3AED);
}

class AppStrings {
  static const String appName = 'Bangkok University Campus';
  static const String appDescription = 'Campus navigation and services';
  static const String universityName = 'Bangkok University';
  
  // Сообщения
  static const String welcomeMessage = 'Welcome to Bangkok University!';
  static const String scanQRInstructions = 'Scan QR codes around campus to discover places and earn rewards';
  static const String aiAssistantHelp = 'Ask me anything about campus: "Where is library?", "I\'m hungry", etc.';
}

class ApiEndpoints {
  // В будущем можно добавить эндпоинты API
  static const String baseUrl = 'https://api.bangkok-university.edu';
  static const String mapData = '/api/map-data';
  static const String foodMenu = '/api/food-menu';
  static const String airQuality = '/api/air-quality';
  static const String busSchedule = '/api/bus-schedule';
  static const String liveAlerts = '/api/live-alerts';
}

class LocalStorageKeys {
  static const String userData = 'user_data';
  static const String activityProgress = 'activity_progress';
  static const String visitedStations = 'visited_stations';
  static const String savedDiscounts = 'saved_discounts';
  static const String preferences = 'user_preferences';
}
