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
- Mapbox Access Token

### Download
```bash
# Clone repo
git clone git@github.com:Rimk4/university-map.git
cd university-map

# Create dependencies
flutter pub get

# Configure environment
cp .env.example .env
# Add your Mapbox access token to .env file
```
