import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ActivityProvider with ChangeNotifier {
  static const String _prefsKey = 'user_activity_data';
  static const String _prefsWeeklyKey = 'weekly_stats';
  static const String _prefsStationsKey = 'stations_data';

  List<Map<String, dynamic>> _stations = [];
  List<Map<String, dynamic>> _weeklyStats = [];
  List<Map<String, dynamic>> _achievements = [];
  UserActivity _userActivity = UserActivity(
    distanceWalked: 0.0,
    caloriesBurned: 0,
    completionPercentage: 0.0,
    visitedStations: [],
    totalXP: 0,
    achievementsUnlocked: 0,
    lastUpdated: DateTime.now(),
  );

  bool _isLoading = false;

  List<Map<String, dynamic>> get stations => _stations;
  List<Map<String, dynamic>> get weeklyStats => _weeklyStats;
  List<Map<String, dynamic>> get achievements => _achievements;
  UserActivity get userActivity => _userActivity;
  bool get isLoading => _isLoading;

  int get completedStationsCount =>
      _stations.where((s) => s['isCompleted'] == true).length;
  int get totalStationsCount => _stations.length;

  Future<void> loadUserActivity() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Загружаем данные пользователя
      final userData = prefs.getString(_prefsKey);
      if (userData != null) {
        final data = json.decode(userData);
        _userActivity = UserActivity.fromJson(data);
      }

      // Загружаем недельную статистику
      final weeklyData = prefs.getString(_prefsWeeklyKey);
      if (weeklyData != null) {
        _weeklyStats = List<Map<String, dynamic>>.from(json.decode(weeklyData));
      } else {
        _weeklyStats = _generateDefaultWeeklyStats();
      }

      // Загружаем станции
      final stationsData = prefs.getString(_prefsStationsKey);
      if (stationsData != null) {
        _stations = List<Map<String, dynamic>>.from(json.decode(stationsData));
      } else {
        _stations = _generateDefaultStations();
      }

      // Загружаем достижения
      _achievements = _generateDefaultAchievements();

      // Обновляем процент выполнения
      _updateCompletionPercentage();

      // Сохраняем обновленные данные
      await _saveToPrefs();

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user activity: $e');
      }
      // Загружаем демо данные в случае ошибки
      _loadDemoData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadDemoData() {
    _stations = _generateDefaultStations();
    _weeklyStats = _generateDefaultWeeklyStats();
    _achievements = _generateDefaultAchievements();
    _updateCompletionPercentage();
  }

  List<Map<String, dynamic>> _generateDefaultStations() {
    return [
      {
        'id': 'station_1',
        'name': 'Main Entrance',
        'description': 'The main entrance to the university campus',
        'location': {
          'lat': 13.736717,
          'lng': 100.523186,
          'name': 'Main Entrance'
        },
        'points': 10,
        'isCompleted': false,
        'requiredForAchievement': true,
      },
      {
        'id': 'station_2',
        'name': 'Central Library',
        'description': 'The main library with study spaces and books',
        'location': {
          'lat': 13.736817,
          'lng': 100.523286,
          'name': 'Library Building'
        },
        'points': 15,
        'isCompleted': false,
        'requiredForAchievement': true,
      },
      {
        'id': 'station_3',
        'name': 'Science Complex',
        'description': 'Building for science and engineering faculties',
        'location': {
          'lat': 13.737717,
          'lng': 100.524186,
          'name': 'Science Building'
        },
        'points': 20,
        'isCompleted': false,
        'requiredForAchievement': true,
      },
      {
        'id': 'station_4',
        'name': 'Student Center',
        'description': 'Hub for student activities and services',
        'location': {
          'lat': 13.735717,
          'lng': 100.522186,
          'name': 'Student Union'
        },
        'points': 15,
        'isCompleted': false,
        'requiredForAchievement': true,
      },
      {
        'id': 'station_5',
        'name': 'Sports Complex',
        'description': 'Gym, pool, and sports facilities',
        'location': {
          'lat': 13.738717,
          'lng': 100.521186,
          'name': 'Sports Center'
        },
        'points': 25,
        'isCompleted': false,
        'requiredForAchievement': true,
      },
      {
        'id': 'station_6',
        'name': 'Campus Park',
        'description': 'Green area for relaxation and events',
        'location': {
          'lat': 13.736917,
          'lng': 100.520186,
          'name': 'University Park'
        },
        'points': 10,
        'isCompleted': false,
        'requiredForAchievement': true,
      },
    ];
  }

  List<Map<String, dynamic>> _generateDefaultWeeklyStats() {
    final now = DateTime.now();
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return List.generate(7, (index) {
      final day = DateTime(now.year, now.month, now.day - (6 - index));
      final distance = index == 2
          ? 3.5
          : index == 4
              ? 4.2
              : index == 6
                  ? 5.0
                  : (1.0 + index * 0.5);

      return {
        'day': weekdays[index],
        'date': '${day.day}/${day.month}',
        'distance': distance,
        'calories': (distance * 70).round(),
        'stations': index == 2
            ? 2
            : index == 4
                ? 3
                : index == 6
                    ? 1
                    : 0,
      };
    });
  }

  List<Map<String, dynamic>> _generateDefaultAchievements() {
    final completedCount = completedStationsCount;

    return [
      {
        'id': 'achievement_1',
        'name': 'First Steps',
        'description': 'Complete your first station',
        'icon': 'directions_walk',
        'isUnlocked': completedCount >= 1,
        'requiredStations': 1,
        'rewardXP': 50,
      },
      {
        'id': 'achievement_2',
        'name': 'Halfway There',
        'description': 'Complete 50% of stations',
        'icon': 'star_half',
        'isUnlocked': completedCount >= (_stations.length ~/ 2),
        'requiredStations': _stations.length ~/ 2,
        'rewardXP': 100,
      },
      {
        'id': 'achievement_3',
        'name': 'Campus Explorer',
        'description': 'Complete all stations',
        'icon': 'explore',
        'isUnlocked': completedCount == _stations.length,
        'requiredStations': _stations.length,
        'rewardXP': 250,
      },
      {
        'id': 'achievement_4',
        'name': 'Distance Master',
        'description': 'Walk 10km on campus',
        'icon': 'directions',
        'isUnlocked': _userActivity.distanceWalked >= 10.0,
        'requiredDistance': 10.0,
        'rewardXP': 150,
      },
      {
        'id': 'achievement_5',
        'name': 'Calorie Burner',
        'description': 'Burn 1000 calories',
        'icon': 'local_fire_department',
        'isUnlocked': _userActivity.caloriesBurned >= 1000,
        'requiredCalories': 1000,
        'rewardXP': 200,
      },
    ];
  }

  void markStationComplete(String stationId) async {
    final index = _stations.indexWhere((s) => s['id'] == stationId);
    if (index != -1 && !_stations[index]['isCompleted']) {
      // Помечаем станцию как выполненную
      _stations[index]['isCompleted'] = true;

      // Добавляем в список посещенных
      if (!_userActivity.visitedStations.contains(stationId)) {
        _userActivity = _userActivity.copyWith(
          visitedStations: [..._userActivity.visitedStations, stationId],
        );
      }

      // Добавляем очки опыта
      final points = _stations[index]['points'] ?? 10;
      _userActivity = _userActivity.copyWith(
        totalXP: _userActivity.totalXP + points,
      );

      // Обновляем достижения
      _achievements = _generateDefaultAchievements();
      _userActivity = _userActivity.copyWith(
        achievementsUnlocked:
            _achievements.where((a) => a['isUnlocked'] == true).length,
      );

      // Обновляем процент выполнения
      _updateCompletionPercentage();

      // Сохраняем изменения
      await _saveToPrefs();
      notifyListeners();
    }
  }

  void updateActivity(double distance) async {
    final calories = _calculateCalories(distance);

    _userActivity = _userActivity.copyWith(
      distanceWalked: _userActivity.distanceWalked + distance,
      caloriesBurned: _userActivity.caloriesBurned + calories,
      lastUpdated: DateTime.now(),
    );

    // Обновляем недельную статистику
    _updateWeeklyStats(distance, calories);

    // Обновляем достижения
    _achievements = _generateDefaultAchievements();
    _userActivity = _userActivity.copyWith(
      achievementsUnlocked:
          _achievements.where((a) => a['isUnlocked'] == true).length,
    );

    await _saveToPrefs();
    notifyListeners();
  }

  int _calculateCalories(double distance) {
    // Базовая формула: 70 калорий на км для среднего веса
    return (distance * 70).round();
  }

  void _updateWeeklyStats(double distance, int calories) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Находим запись на сегодня
    final index = _weeklyStats.indexWhere((stat) {
      final statDate = stat['date'] as String;
      final parts = statDate.split('/');
      if (parts.length == 2) {
        final statDay = DateTime(now.year, now.month, int.parse(parts[0]));
        return statDay == today;
      }
      return false;
    });

    if (index != -1) {
      _weeklyStats[index]['distance'] += distance;
      _weeklyStats[index]['calories'] += calories;
    } else {
      // Добавляем новый день
      _weeklyStats.add({
        'day': [
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
          'Sun'
        ][now.weekday - 1],
        'date': '${now.day}/${now.month}',
        'distance': distance,
        'calories': calories,
        'stations': 0,
      });

      // Ограничиваем 7 днями
      if (_weeklyStats.length > 7) {
        _weeklyStats.removeAt(0);
      }
    }
  }

  void _updateCompletionPercentage() {
    final completedCount = completedStationsCount;
    final totalCount = _stations.length;

    if (totalCount > 0) {
      _userActivity = _userActivity.copyWith(
        completionPercentage: (completedCount / totalCount) * 100,
      );
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Сохраняем данные пользователя
    await prefs.setString(_prefsKey, json.encode(_userActivity.toJson()));

    // Сохраняем недельную статистику
    await prefs.setString(_prefsWeeklyKey, json.encode(_weeklyStats));

    // Сохраняем станции
    await prefs.setString(_prefsStationsKey, json.encode(_stations));
  }

  Map<String, dynamic>? getNextStation() {
    return _stations.firstWhere(
      (station) => !station['isCompleted'],
      orElse: () => _stations.isNotEmpty ? _stations.last : null,
    );
  }

  int calculateLevel() {
    // Уровень на основе опыта: 100 XP на уровень
    return (_userActivity.totalXP ~/ 100) + 1;
  }

  int calculateXP() {
    return _userActivity.totalXP;
  }

  Duration calculateTimeSpent() {
    // Расчет на основе пройденного расстояния
    // Средняя скорость пешехода: 5 км/ч
    final hours = _userActivity.distanceWalked / 5;
    return Duration(minutes: (hours * 60).round());
  }

  int calculateAchievements() {
    return _achievements.where((a) => a['isUnlocked'] == true).length;
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    await prefs.remove(_prefsWeeklyKey);
    await prefs.remove(_prefsStationsKey);

    _userActivity = UserActivity(
      distanceWalked: 0.0,
      caloriesBurned: 0,
      completionPercentage: 0.0,
      visitedStations: [],
      totalXP: 0,
      achievementsUnlocked: 0,
      lastUpdated: DateTime.now(),
    );

    _stations = _generateDefaultStations();
    _weeklyStats = _generateDefaultWeeklyStats();
    _achievements = _generateDefaultAchievements();

    notifyListeners();
  }
}
