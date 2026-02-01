class MapStyle {
  static const String lightTheme = '''
{
  "version": 8,
  "name": "Light Theme",
  "metadata": {
    "mapbox:autocomposite": true
  },
  "sources": {
    "composite": {
      "url": "mapbox://mapbox.mapbox-streets-v8",
      "type": "vector"
    }
  },
  "layers": [
    {
      "id": "background",
      "type": "background",
      "paint": {
        "background-color": "#f8f9fa"
      }
    }
  ],
  "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
  "sprite": "mapbox://sprites/mapbox/streets-v11"
}
''';

  static const String darkTheme = '''
{
  "version": 8,
  "name": "Dark Theme",
  "metadata": {
    "mapbox:autocomposite": true
  },
  "sources": {
    "composite": {
      "url": "mapbox://mapbox.mapbox-streets-v8",
      "type": "vector"
    }
  },
  "layers": [
    {
      "id": "background",
      "type": "background",
      "paint": {
        "background-color": "#1a1a1a"
      }
    }
  ],
  "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
  "sprite": "mapbox://sprites/mapbox/dark-v11"
}
''';

  static const String campusTheme = '''
{
  "version": 8,
  "name": "Campus Theme",
  "metadata": {
    "mapbox:autocomposite": true
  },
  "sources": {
    "composite": {
      "url": "mapbox://mapbox.mapbox-streets-v8",
      "type": "vector"
    }
  },
  "layers": [
    {
      "id": "background",
      "type": "background",
      "paint": {
        "background-color": "#e8f5e8"
      }
    },
    {
      "id": "landuse_park",
      "type": "fill",
      "source": "composite",
      "source-layer": "landuse",
      "filter": ["==", ["get", "class"], "park"],
      "paint": {
        "fill-color": "#d4edda",
        "fill-opacity": 0.7
      }
    },
    {
      "id": "landuse_school",
      "type": "fill",
      "source": "composite",
      "source-layer": "landuse",
      "filter": ["==", ["get", "class"], "school"],
      "paint": {
        "fill-color": "#fff3cd",
        "fill-opacity": 0.8
      }
    }
  ],
  "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
  "sprite": "mapbox://sprites/mapbox/light-v11"
}
''';

  // Стили для маркеров
  static const Map<String, dynamic> markerStyles = {
    "academic": {"color": "#007bff", "icon": "school", "size": 1.2},
    "library": {"color": "#28a745", "icon": "library_books", "size": 1.3},
    "dining": {"color": "#dc3545", "icon": "restaurant", "size": 1.1},
    "sport": {"color": "#ffc107", "icon": "sports_soccer", "size": 1.4},
    "dormitory": {"color": "#6f42c1", "icon": "home", "size": 1.2}
  };
}
