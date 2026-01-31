// Удаляем зависимость от CampusLocation
class QRCode {
  final String id;
  final String name;
  final String description;
  final double discount;
  final bool isStation;
  
  QRCode({
    required this.id,
    required this.name,
    required this.description,
    required this.discount,
    required this.isStation,
  });
}

class QRStation {
  final String id;
  final String name;
  final Map<String, dynamic> location; // Используем Map вместо CampusLocation
  final bool isCompleted;
  
  QRStation({
    required this.id,
    required this.name,
    required this.location,
    required this.isCompleted,
  });
}
