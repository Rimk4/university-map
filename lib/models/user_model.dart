import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final DateTime? joinedDate;
  final String? department;
  final String? studentId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.joinedDate,
    this.department,
    this.studentId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'] as String)
          : null,
      department: json['department'] as String?,
      studentId: json['studentId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'joinedDate': joinedDate?.toIso8601String(),
      'department': department,
      'studentId': studentId,
    };
  }
}

@immutable
class UserActivity {
  final double distanceWalked;
  final int caloriesBurned;
  final double completionPercentage;
  final List<String> visitedStations;
  final int totalXP;
  final int achievementsUnlocked;
  final DateTime lastUpdated;

  const UserActivity({
    required this.distanceWalked,
    required this.caloriesBurned,
    required this.completionPercentage,
    required this.visitedStations,
    required this.totalXP,
    required this.achievementsUnlocked,
    required this.lastUpdated,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return UserActivity(
      distanceWalked: (json['distanceWalked'] as num).toDouble(),
      caloriesBurned: json['caloriesBurned'] as int,
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      visitedStations: List<String>.from(json['visitedStations']),
      totalXP: json['totalXP'] as int,
      achievementsUnlocked: json['achievementsUnlocked'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distanceWalked': distanceWalked,
      'caloriesBurned': caloriesBurned,
      'completionPercentage': completionPercentage,
      'visitedStations': visitedStations,
      'totalXP': totalXP,
      'achievementsUnlocked': achievementsUnlocked,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  UserActivity copyWith({
    double? distanceWalked,
    int? caloriesBurned,
    double? completionPercentage,
    List<String>? visitedStations,
    int? totalXP,
    int? achievementsUnlocked,
    DateTime? lastUpdated,
  }) {
    return UserActivity(
      distanceWalked: distanceWalked ?? this.distanceWalked,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      visitedStations: visitedStations ?? this.visitedStations,
      totalXP: totalXP ?? this.totalXP,
      achievementsUnlocked: achievementsUnlocked ?? this.achievementsUnlocked,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

@immutable
class QRStation {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> location;
  final int points;
  final bool isCompleted;
  final DateTime? completedAt;
  final List<String> requiredItems;

  const QRStation({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.points = 10,
    this.isCompleted = false,
    this.completedAt,
    this.requiredItems = const [],
  });

  factory QRStation.fromJson(Map<String, dynamic> json) {
    return QRStation(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      location: Map<String, dynamic>.from(json['location']),
      points: json['points'] as int? ?? 10,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      requiredItems: List<String>.from(json['requiredItems'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'points': points,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'requiredItems': requiredItems,
    };
  }
}

@immutable
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int rewardXP;
  final Map<String, dynamic>? requirements;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    this.unlockedAt,
    this.rewardXP = 0,
    this.requirements,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      rewardXP: json['rewardXP'] as int? ?? 0,
      requirements: json['requirements'] != null
          ? Map<String, dynamic>.from(json['requirements'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'rewardXP': rewardXP,
      'requirements': requirements,
    };
  }
}
