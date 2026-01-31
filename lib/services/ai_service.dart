import '../models/campus_model.dart';

class AIService {
  Future<String> processQuery(String query) async {
    // Демо AI обработка
    await Future.delayed(const Duration(seconds: 1));
    
    if (query.toLowerCase().contains('hungry') || query.toLowerCase().contains('food')) {
      return 'The nearest cafeteria is at the Main Building. It has affordable meals starting from 50฿.';
    } else if (query.toLowerCase().contains('library')) {
      return 'The main library is located next to the Administration Building. Open 8:00-20:00.';
    } else if (query.toLowerCase().contains('cheap')) {
      return 'The cheapest meal is at Student Cafeteria: Fried Rice for 40฿ (450 calories).';
    }
    
    return 'I found information about that. Check the campus map for details.';
  }
  
  Future<CampusLocation?> findLocation(String query) async {
    // Поиск местоположения по запросу
    if (query.toLowerCase().contains('library')) {
      return CampusLocation(lat: 13.736817, lng: 100.523286, name: 'Library');
    } else if (query.toLowerCase().contains('cafeteria')) {
      return CampusLocation(lat: 13.735717, lng: 100.522186, name: 'Cafeteria');
    }
    
    return null;
  }
}
