# 📱 Mobile Playground

A Flutter playground project for experimenting with mobile development concepts, testing new features, and implementing best practices.

## 🎯 Project Overview

This repository serves as a sandbox for mobile development experimentation and learning. It's designed to test various Flutter features, implementation patterns, and development workflows.

## ✅ Accomplishments

### 🚀 CI/CD Pipeline Implementation

Automated GitHub Actions pipeline for continuous integration and deployment.

**Features:**
- Automated code quality checks (formatting, analysis, tests)
- Coverage reporting with Codecov
- Automated Android builds on version tags
- GitHub release creation with APK and App Bundle artifacts

### 📱 NFC Scanning Feature

Multi-platform NFC tag reader supporting 8 different tag technologies.

**Features:**
- Support for ISO 14443, ISO 15693, ISO 18092, MIFARE, and NDEF
- Animated scanning UI with real-time feedback
- Automatic availability detection and error handling
- Android foreground dispatch for priority NFC handling
- Riverpod state management with clean architecture

**Documentation:** [`lib/nfc_scanner/docs/NFC_IMPLEMENTATION.md`](lib/nfc_scanner/docs/NFC_IMPLEMENTATION.md)

### 🗺️ Location & Maps Feature

Interactive map interface with real-time location tracking and turn-by-turn directions.

**Features:**
- Real-time user location detection with permission handling
- Google Maps integration with custom markers and polylines
- Place search with autocomplete suggestions
- Route calculation using Google Directions API
- Animated camera movements to fit routes
- Dotted polyline route visualization
- Service-oriented architecture for maintainability

**Technologies:**
- Google Maps Flutter SDK
- Geolocator for device location
- Google Places API for autocomplete
- Google Directions API for routing
- Geocoding for address conversion

**Documentation:** [`docs/location/location-implementation.md`](docs/location/location-implementation.md)

## 🛠 Getting Started

### Prerequisites
- Flutter SDK (3.24.0 or later)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd mobile-playground

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configuration

#### Google Maps API Key Setup

For the location feature to work, you need to set up a Google Maps API key:

1. Create a `.env` file in the project root:
```bash
GOOGLE_MAPS_API_KEY=your_api_key_here
```

2. Enable the following APIs in Google Cloud Console:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Directions API
   - Places API
   - Geocoding API

3. See the [location implementation documentation](docs/location/location-implementation.md) for detailed setup instructions.

### Development Commands
```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

## 🔄 CI/CD Status

The project includes automated workflows for quality assurance and deployment. Check the Actions tab to monitor build status and download the latest releases from the Releases section.
