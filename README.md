# Run
flutter run

# Release build for Android
flutter build apk --release

# Clean Flutter cache
flutter clean

# Remove dependencies and reinstall
rm -rf pubspec.lock
flutter pub get

# Get all dependencies
flutter pub get

# Upgrade dependencies to latest versions
flutter pub upgrade

# University Campus Map App

Mobile application for university campus navigation using Flutter

## 🚀 Quick start

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart (>=2.19.0)
- Android Studio / Xcode (for emulation)

### Download
```bash
# Clone repo
git clone git@github.com:Rimk4/university-map.git
cd university-map

# Create dependencies
flutter pub get
```

bangkok_university/  
├── lib/  
│   ├── main.dart  
│   ├── app.dart  
│   ├── models/  
│   │   ├── campus_model.dart  
│   │   ├── user_model.dart  
│   │   ├── qr_model.dart  
│   │   ├── food_model.dart  
│   │   └── route_model.dart  
│   ├── services/  
│   │   ├── map_service.dart  
│   │   ├── location_service.dart  
│   │   ├── qr_service.dart  
│   │   ├── ai_service.dart  
│   │   └── api_service.dart  
│   ├── providers/  
│   │   ├── map_provider.dart  
│   │   ├── user_provider.dart  
│   │   ├── activity_provider.dart  
│   │   └── qr_provider.dart  
│   ├── screens/  
│   │   ├── home_screen.dart  
│   │   ├── map_screen.dart  
│   │   ├── qr_scanner.dart  
│   │   ├── activity_screen.dart  
│   │   ├── search_screen.dart  
│   │   └── settings_screen.dart  
│   ├── widgets/  
│   │   ├── campus_map.dart  
│   │   ├── building_card.dart  
│   │   ├── activity_tracker.dart  
│   │   ├── route_planner.dart  
│   │   ├── food_finder.dart  
│   │   ├── air_quality.dart  
│   │   └── live_comments.dart  
│   └── utils/  
│       ├── constants.dart  
│       ├── helpers.dart  
│       └── map_style.dart  
├── assets/  
│   ├── images/  
│   ├── icons/  
│   ├── data/  
│   │   └── campus_data.json  
│   └── fonts/  
└── pubspec.yaml  
