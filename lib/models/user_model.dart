class User {
  final String id;
  final String name;
  final String email;
  final String role;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

class UserActivity {
  final double distanceWalked;
  final int caloriesBurned;
  final double completionPercentage;
  final List<String> visitedStations;
  
  UserActivity({
    required this.distanceWalked,
    required this.caloriesBurned,
    required this.completionPercentage,
    required this.visitedStations,
  });
}
