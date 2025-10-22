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
