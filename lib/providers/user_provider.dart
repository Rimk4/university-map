import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  UserActivity? _userActivity;
  
  User? get currentUser => _currentUser;
  UserActivity? get userActivity => _userActivity;
  
  Future<void> loadUserData() async {
    // Демо данные
    _currentUser = User(
      id: '1',
      name: 'Student',
      email: 'student@bangkok.ac.th',
      role: 'student',
    );
    
    _userActivity = UserActivity(
      distanceWalked: 2.5,
      caloriesBurned: 150,
      completionPercentage: 30.0,
      visitedStations: ['station_1', 'station_2'],
    );
    
    notifyListeners();
  }
}
