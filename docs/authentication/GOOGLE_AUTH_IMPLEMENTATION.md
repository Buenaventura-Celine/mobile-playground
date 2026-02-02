# Google Sign-In/Login Implementation Plan

## Overview
This document outlines the technical implementation strategy for integrating Google authentication into the Mobile Playground app. The authentication flow follows this sequence:

```
Sign in via Google → Home screen (with logout) → Logout → Login screen → Login again → Home screen
```

---

## User Flow Diagram

```
┌─────────────────────────┐
│   Authentication Screen  │
│  (Google Sign-In Button) │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Google OAuth Flow      │
│  (Web/Mobile)           │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Home Screen            │
│  - User Profile         │
│  - Logout Button        │
└────────────┬────────────┘
             │
         ┌───┴────────────────────┐
         │ User clicks Logout     │
         └───┬────────────────────┘
             │
             ▼
┌─────────────────────────┐
│  Authentication Screen  │
│  (Login/Sign-In)        │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Home Screen            │
│  (Repeat cycle)         │
└─────────────────────────┘
```

---

## Phase 1: Project Setup & Dependencies

### 1.1 Add Required Packages
Add the following packages to `pubspec.yaml`:

```yaml
dependencies:
  google_sign_in: ^6.2.1        # Official Google Sign-In SDK
  firebase_core: ^3.4.1          # Firebase Core
  firebase_auth: ^5.2.0          # Firebase Authentication
  google_identity_services: ^0.2.2 # For web support
  secure_storage: ^5.1.2         # Secure token storage (optional but recommended)
```

Run `flutter pub get` to fetch dependencies.

### 1.2 Platform-Specific Configuration

#### Android Configuration (`android/app/build.gradle`)
- Ensure minSdkVersion is at least 21
- Add Google Play Services dependency
- Configure Google OAuth credentials

#### iOS Configuration (`ios/Podfile`)
- Ensure platform minimum is iOS 14.0+
- CocoaPods will handle Google Sign-In dependencies

#### Web Configuration
- Update `web/index.html` to include Google Platform Library
- Configure OAuth 2.0 credentials

---

## Phase 2: Authentication Service Layer

### 2.1 Create Authentication Models

**File: `lib/authentication/domain/models/user_model.dart`**

```dart
// Define user data model
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
  });
}
```

**File: `lib/authentication/domain/models/auth_state.dart`**

```dart
// Freezed model for authentication states
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });
}
```

### 2.2 Create Authentication Repository

**File: `lib/authentication/data/repositories/auth_repository.dart`**

Responsibilities:
- Handle Google Sign-In initialization
- Manage sign-in/sign-out operations
- Store user session/tokens
- Verify authentication state on app launch
- Manage token refresh

Key Methods:
```dart
class AuthRepository {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<bool> isAuthenticated();
  Stream<UserModel?> authStateChanges();
}
```

### 2.3 Create Authentication Service

**File: `lib/authentication/services/google_auth_service.dart`**

Responsibilities:
- Initialize Google Sign-In with proper configurations
- Handle the authentication flow
- Manage platform-specific logic
- Error handling and user feedback

Key Methods:
```dart
class GoogleAuthService {
  Future<GoogleSignInAccount?> signIn();
  Future<void> signOut();
  GoogleSignInAccount? get currentUser;
  Future<GoogleSignInAuthentication> getAuthentication();
}
```

---

## Phase 3: State Management (Riverpod)

### 3.1 Create Authentication Providers

**File: `lib/authentication/application/providers/auth_provider.dart`**

```dart
// User provider - holds current authenticated user
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>((ref) {
  return UserNotifier(ref.watch(authRepositoryProvider));
});

// Authentication status provider
final authStatusProvider = StreamProvider<AuthStatus>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateStream();
});

// Is authenticated provider - boolean helper
final isAuthenticatedProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(userProvider);
  return userAsync.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});
```

### 3.2 Create State Notifiers

**File: `lib/authentication/application/notifiers/auth_notifier.dart`**

Responsibilities:
- Handle sign-in logic
- Handle sign-out logic
- Update user state
- Manage loading/error states
- Persist authentication state

---

## Phase 4: UI Implementation

### 4.1 Authentication Screen

**File: `lib/authentication/presentation/authentication_screen.dart`**

```dart
// Replace existing empty button with complete implementation
class AuthenticationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Mobile Playground'),
            SizedBox(height: 40),
            GoogleSignInButton(), // Custom button component
          ],
        ),
      ),
    );
  }
}
```

### 4.2 Google Sign-In Button Component

**File: `lib/authentication/presentation/widgets/google_sign_in_button.dart`**

Features:
- Handle loading state
- Display error messages
- Trigger sign-in on press
- Navigate to home on success

### 4.3 Home Screen Updates

**File: `lib/home/presentation/home_screen.dart` (Modify)**

Add:
- Display current user info (email, name, avatar)
- Add logout button in AppBar or drawer
- Handle logout confirmation dialog
- Navigate to authentication screen after logout

### 4.4 Loading/Error States

Create UI components for:
- Loading spinner during authentication
- Error snackbar/dialog for failed authentication
- Network error handling

---

## Phase 5: Navigation Flow

### 5.1 Create Routing Configuration

**File: `lib/config/router/app_router.dart`**

```dart
// Use GoRouter with AuthGuard middleware
final appRouter = GoRouter(
  redirect: (context, state) {
    // Check authentication status and redirect accordingly
    final isAuthed = ref.watch(isAuthenticatedProvider);

    if (!isAuthed && state.location != '/auth') {
      return '/auth';
    }
    if (isAuthed && state.location == '/auth') {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/auth', builder: (context, state) => AuthenticationScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
  ],
);
```

### 5.2 App Initialization

**File: `lib/main.dart` (Modify)**

On app startup:
1. Check if user is already authenticated
2. Restore session from secure storage
3. Navigate to appropriate screen (home or auth)
4. Handle any stored errors or messages

---

## Phase 6: Testing & Error Handling

### 6.1 Error Scenarios to Handle

- **Network Error**: No internet connection during sign-in
- **Cancelled Flow**: User cancels Google Sign-In dialog
- **Invalid Token**: Token expired or revoked
- **API Error**: Google API returns error
- **Local Storage Error**: Failed to save/retrieve credentials

### 6.2 Error Handling Strategy

```dart
try {
  final user = await authRepository.signInWithGoogle();
  // Handle success
} on SocketException {
  // Network error
  showErrorDialog('Check your internet connection');
} on PlatformException catch (e) {
  // Platform-specific error (Google Sign-In)
  showErrorDialog(e.message);
} catch (e) {
  // Generic error
  showErrorDialog('Authentication failed');
}
```

### 6.3 User Session Management

- Implement token refresh mechanism
- Auto-logout on token expiration
- Handle app resume/pause lifecycle events
- Validate user session on app startup

---

## Phase 7: Deployment

### 7.1 Firebase Setup (if using Firebase Auth)

1. Create Firebase project in Firebase Console
2. Configure Android, iOS, and Web apps
3. Download/configure credentials
4. Enable Google Sign-In as authentication provider

### 7.2 OAuth Credentials

1. Create OAuth 2.0 credentials in Google Cloud Console
2. Configure Web, Android, and iOS application types
3. Set authorized redirect URIs/custom schemes
4. Download credentials files

### 7.3 Android-Specific

- Add SHA-1/SHA-256 fingerprints to OAuth credentials
- Test on physical device (Google Sign-In may not work on emulator)
- Verify manifest permissions

### 7.4 iOS-Specific

- Configure URL schemes for Google Sign-In callback
- Update Info.plist with required keys
- Test on physical device

### 7.5 Web-Specific

- Add Google Platform Library to HTML
- Configure CORS settings
- Test on different browsers

---

## File Structure

```
lib/
├── authentication/
│   ├── application/
│   │   ├── notifiers/
│   │   │   └── auth_notifier.dart
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   └── services/
│   │       └── google_auth_service.dart
│   ├── data/
│   │   ├── datasources/
│   │   │   └── auth_local_datasource.dart
│   │   └── repositories/
│   │       └── auth_repository.dart
│   ├── domain/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   └── auth_state.dart
│   │   └── repositories/
│   │       └── auth_repository_interface.dart
│   └── presentation/
│       ├── authentication_screen.dart
│       └── widgets/
│           ├── google_sign_in_button.dart
│           └── user_profile_widget.dart
├── config/
│   └── router/
│       └── app_router.dart
└── main.dart
```

---

## Key Dependencies & Their Roles

| Package | Purpose |
|---------|---------|
| `google_sign_in` | Official Google Sign-In SDK |
| `firebase_auth` | Secure authentication backend |
| `firebase_core` | Firebase initialization |
| `flutter_riverpod` | State management |
| `go_router` | Navigation & routing |
| `secure_storage` | Encrypted token/session storage |

---

## Implementation Checklist

- [ ] Add dependencies to pubspec.yaml
- [ ] Configure Android/iOS/Web platforms
- [ ] Create authentication models
- [ ] Implement AuthRepository
- [ ] Implement GoogleAuthService
- [ ] Create Riverpod providers
- [ ] Update AuthenticationScreen UI
- [ ] Create GoogleSignInButton widget
- [ ] Update HomeScreen with user info & logout
- [ ] Configure GoRouter with auth guard
- [ ] Implement error handling
- [ ] Add user session restoration on app launch
- [ ] Test on Android device
- [ ] Test on iOS device
- [ ] Test on Web (if applicable)
- [ ] Set up Firebase/OAuth credentials
- [ ] Deploy to respective app stores

---

## Security Considerations

1. **Token Storage**: Store tokens in secure storage (iOS Keychain, Android Keystore)
2. **Token Expiration**: Implement token refresh mechanism
3. **Revocation**: Handle token revocation gracefully
4. **HTTPS**: Always use HTTPS for API calls
5. **Sensitive Data**: Never log tokens or sensitive user data
6. **Credential Validation**: Verify credentials on app startup
7. **Certificate Pinning** (optional): Implement for enhanced security

---

## Testing Strategy

### Unit Tests
- Test AuthRepository methods
- Test state notifier logic
- Test model serialization/deserialization

### Widget Tests
- Test authentication screen UI
- Test sign-in button interactions
- Test home screen logout flow

### Integration Tests
- Test complete sign-in flow
- Test session persistence
- Test logout and re-authentication

### Manual Testing
- Test on real devices (Android & iOS)
- Test with poor network conditions
- Test token expiration scenarios
- Test concurrent sign-in attempts

---

## Performance Optimization

1. **Lazy Loading**: Load user profile data after authentication
2. **Caching**: Cache user profile to avoid repeated API calls
3. **Token Refresh**: Refresh tokens before expiration (not on demand)
4. **Minimize Rebuilds**: Use Riverpod selectors to prevent unnecessary rebuilds

---

## Troubleshooting Guide

### Common Issues

| Issue | Solution |
|-------|----------|
| Google Sign-In fails on emulator | Test on physical device |
| Token expired error | Implement token refresh mechanism |
| CORS errors on web | Check OAuth credentials configuration |
| App crashes after sign-in | Check platform-specific configuration |
| User redirects to login repeatedly | Verify token persistence logic |

---

## Next Steps

1. Start with Phase 1 (Dependencies)
2. Move through each phase sequentially
3. Test at the end of each phase
4. Refactor and optimize after complete implementation
5. Deploy to production

---

## References

- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Riverpod State Management](https://riverpod.dev)
- [Flutter Security Best Practices](https://flutter.dev/docs/testing/best-practices)
