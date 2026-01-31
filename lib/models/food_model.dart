class FoodPlace {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> location; // Используем Map
  final double averagePrice;
  final double rating;
  
  FoodPlace({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.averagePrice,
    required this.rating,
  });
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final int? calories;
  
  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.calories,
  });
}
