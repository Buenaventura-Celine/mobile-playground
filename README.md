# 📱 Mobile Playground

A Flutter playground project for experimenting with mobile development concepts, testing new features, and implementing best practices.

## 🎯 Project Overview

This repository serves as a sandbox for mobile development experimentation and learning. It's designed to test various Flutter features, implementation patterns, and development workflows.

## ✅ Accomplishments

### 🚀 CI/CD Pipeline Implementation

**First major milestone**: Successfully implemented a comprehensive CI/CD pipeline using GitHub Actions.

**Implementation Details:**

- **Continuous Integration (CI)**: 
  - Triggers on every push and pull request to `main` branch
  - Automated code quality checks including formatting and static analysis
  - Comprehensive test suite execution with coverage reporting
  - Integration with Codecov for coverage tracking

- **Continuous Deployment (CD)**:
  - Triggers on version tags (e.g., `v1.0.0`)
  - Automated Android APK and App Bundle builds
  - Automatic GitHub release creation with build artifacts
  - Ready-to-install APK files for direct distribution
  - App Bundle files prepared for Google Play Store deployment

**Workflow Features:**
- Flutter 3.24.0 stable channel
- Java 17 setup for Android builds
- Automated testing before deployment
- Release asset uploads with versioned naming

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
