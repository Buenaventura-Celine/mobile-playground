# CI/CD Setup for Mobile Playground

This document describes the CI/CD pipeline setup for the Mobile Playground Flutter project using GitHub Actions.

## Overview

The CI/CD pipeline consists of two main workflows:

1. **Continuous Integration (CI)** - Runs on every push to any branch and pull requests to main
2. **Continuous Deployment (CD)** - Runs when a tag is pushed to create releases

## Workflows

### 1. CI Workflow (`.github/workflows/ci.yml`)

**Triggers:**
- Push to any branch
- Pull requests to `main` branch

**Steps:**
1. **Checkout code** - Downloads the repository code
2. **Setup Flutter** - Installs Flutter SDK (version 3.24.0, stable channel)
3. **Install dependencies** - Runs `flutter pub get`
4. **Verify formatting** - Checks code formatting with `flutter format`
5. **Analyze project** - Runs static analysis with `flutter analyze`
6. **Run tests** - Executes all tests with coverage using `flutter test --coverage`
7. **Upload coverage** - Sends coverage reports to Codecov (optional)

**Purpose:** Ensures code quality, formatting, and that all tests pass on every commit and before merging changes.

### 2. CD Workflow (`.github/workflows/cd.yml`)

**Triggers:**
- Push of tags matching pattern `v*` (e.g., v1.0.0, v2.1.3)

**Steps:**
1. **Checkout code** - Downloads the repository code
2. **Setup Java** - Installs Java 17 (required for Android builds)
3. **Setup Flutter** - Installs Flutter SDK (version 3.24.0, stable channel)
4. **Install dependencies** - Runs `flutter pub get`
5. **Run tests** - Ensures all tests pass before building
6. **Build APK** - Creates release APK with `flutter build apk --release`
7. **Build App Bundle** - Creates AAB file with `flutter build appbundle --release`
8. **Create Release** - Creates a GitHub release with release notes
9. **Upload APK** - Attaches the APK file to the release
10. **Upload App Bundle** - Attaches the AAB file to the release

**Purpose:** Automatically builds and releases the app when a new version tag is created.

## How to Use

### Running CI

The CI workflow runs automatically when you:
```bash
# Push changes to any branch
git push origin feature/new-feature
git push origin main
git push origin develop

# Create a pull request to main
git checkout -b feature/new-feature
git push origin feature/new-feature
# Then create PR through GitHub UI
```

### Creating a Release

To trigger the CD workflow and create a release:

1. **Update version in `pubspec.yaml`:**
   ```yaml
   version: 1.0.1+2  # Update version number
   ```

2. **Commit and push changes:**
   ```bash
   git add pubspec.yaml
   git commit -m "Bump version to 1.0.1"
   git push origin main
   ```

3. **Create and push a tag:**
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

4. **Monitor the workflow:**
   - Go to your GitHub repository
   - Click on "Actions" tab
   - Watch the CD workflow build your app
   - Once complete, check the "Releases" section for your new release

## File Structure

```
.github/
└── workflows/
    ├── ci.yml      # Continuous Integration workflow
    └── cd.yml      # Continuous Deployment workflow
```

## Requirements

### Repository Settings

Ensure your GitHub repository has the following:

1. **Actions enabled** (Settings → Actions → General)
2. **Workflow permissions** set to "Read and write permissions" (Settings → Actions → General → Workflow permissions)

### Secrets (Optional)

For enhanced functionality, you can add these secrets in your repository settings:

- `CODECOV_TOKEN` - For coverage reporting (optional)

## Troubleshooting

### Common Issues

1. **Build fails on Java setup:**
   - The workflow uses Java 17, which is required for current Flutter/Android builds
   - If you need a different Java version, update the `java-version` in cd.yml

2. **Flutter version issues:**
   - The workflows are set to use Flutter 3.24.0
   - Update the `flutter-version` in both files if you need a different version

3. **Tests failing:**
   - Ensure all tests pass locally before pushing
   - Run `flutter test` locally to debug issues

4. **Tag-based releases not working:**
   - Ensure you're pushing tags with the format `v*` (e.g., v1.0.0)
   - Use `git push origin v1.0.0` to push the tag

### Workflow Status

You can monitor workflow status in several ways:

1. **GitHub Actions tab** - Real-time status of running workflows
2. **Commit badges** - Shows pass/fail status next to commits
3. **Pull request checks** - CI status is shown in PR reviews

## Customization

### Modifying CI Workflow

To customize the CI workflow:

1. **Add more test commands:**
   ```yaml
   - name: Run integration tests
     run: flutter test integration_test/
   ```

2. **Add different Flutter channels:**
   ```yaml
   strategy:
     matrix:
       flutter-channel: [stable, beta]
   ```

3. **Test on multiple OS:**
   ```yaml
   strategy:
     matrix:
       os: [ubuntu-latest, macos-latest, windows-latest]
   ```

### Modifying CD Workflow

To customize the CD workflow:

1. **Add iOS builds:**
   ```yaml
   - name: Build iOS
     run: flutter build ios --release --no-codesign
   ```

2. **Add different build flavors:**
   ```yaml
   - name: Build production APK
     run: flutter build apk --release --flavor production
   ```

3. **Deploy to app stores:**
   - Add steps to deploy to Google Play Store or Apple App Store
   - Requires additional secrets for store credentials

## Next Steps

1. **Set up code signing** for production releases
2. **Configure store deployment** for automatic publishing
3. **Add performance testing** to the CI pipeline
4. **Set up staging environments** for testing builds

## Support

If you encounter issues with the CI/CD setup:

1. Check the GitHub Actions logs for detailed error messages
2. Ensure your Flutter project builds successfully locally
3. Verify that all required secrets and permissions are configured
4. Review the Flutter and GitHub Actions documentation for updates

---

**Note:** This setup provides a solid foundation for Flutter app CI/CD. You can extend it based on your specific needs, such as adding code signing, store deployment, or additional testing phases.