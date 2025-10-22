# NFC Scanning Implementation Guide

This document provides a comprehensive overview of how NFC (Near Field Communication) scanning was implemented in this Flutter application.

## Table of Contents

- [Overview](#overview)
- [Dependencies](#dependencies)
- [Architecture](#architecture)
- [Platform Configuration](#platform-configuration)
- [Implementation Details](#implementation-details)
- [Usage](#usage)
- [Supported NFC Technologies](#supported-nfc-technologies)
- [Troubleshooting](#troubleshooting)

## Overview

The NFC scanning feature allows users to read various types of NFC tags using their mobile device. The implementation supports both Android and iOS platforms and can read 8 different NFC tag technologies.

**Key Features:**
- Multi-platform support (Android & iOS)
- 8 different NFC tag technology support
- Comprehensive error handling
- Animated scanning UI
- Automatic resource cleanup
- Clean architecture with state management

## Dependencies

### Main Package

```yaml
nfc_manager: ^4.0.2
```

The `nfc_manager` package provides a unified API for NFC operations across Android and iOS platforms.

### Additional Dependencies

```yaml
app_settings: ^5.1.1  # For opening device NFC settings
```

## Architecture

The NFC implementation follows a clean architecture pattern with separation of concerns:

```
lib/nfc_scanner/
├── services/
│   └── nfc_scanner_controller.dart          # Business logic & state management
├── domains/
│   ├── nfc_scanner_state.dart              # State definitions (Freezed)
│   └── nfc_scanner_state.freezed.dart      # Generated state code
└── presentation/
    ├── nfc_scanner_screen.dart             # Main screen with state switching
    └── nfc_screen_types/
        ├── nfc_screen.dart                 # Base screen template
        ├── nfc_checking_screen.dart        # Checking availability state
        ├── nfc_error_screen.dart           # Error state
        ├── nfc_scanning_screen.dart        # Active scanning with animation
        ├── nfc_success_screen.dart         # Success state with tag details
        ├── nfc_turned_off_screen.dart      # NFC disabled state
        └── nfc_unsupported_screen.dart     # Unsupported device state
```

### State Management

The implementation uses **Flutter Riverpod** for state management:

```dart
final nfcScannerProvider = NotifierProvider.autoDispose<
  NfcScannerController,
  NfcScannerState
>(NfcScannerController.new);
```

**State Types:**
- `checking()` - Initial state while checking NFC availability
- `unavailable()` - Device doesn't support NFC
- `disabled()` - NFC is supported but turned off
- `scanning()` - NFC is available and actively scanning
- `success(details)` - Tag successfully read
- `error(message)` - An error occurred

## Platform Configuration

### Android Configuration

#### 1. AndroidManifest.xml

**File:** `android/app/src/main/AndroidManifest.xml`

Add NFC permission:

```xml
<uses-permission android:name="android.permission.NFC" />
```

This permission will be requested at runtime on Android 6.0+.

#### 2. MainActivity.kt - Foreground Dispatch

**File:** `android/app/src/main/kotlin/com/example/mobile_playground/MainActivity.kt`

Custom MainActivity implementation to handle NFC foreground dispatch:

```kotlin
package com.example.mobile_playground
import android.app.PendingIntent
import android.content.Intent
import android.nfc.NfcAdapter
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private var nfcAdapter: NfcAdapter? = null
    private var pendingIntent: PendingIntent? = null

    override fun onResume() {
        super.onResume()

        nfcAdapter = NfcAdapter.getDefaultAdapter(this)

        if (nfcAdapter != null) {
            val intent = Intent(this, javaClass).apply {
                addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            }

            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.FLAG_MUTABLE
            } else {
                0
            }

            pendingIntent = PendingIntent.getActivity(this, 0, intent, flags)
            nfcAdapter?.enableForegroundDispatch(this, pendingIntent, null, null)
        }
    }

    override fun onPause() {
        super.onPause()
        nfcAdapter?.disableForegroundDispatch(this)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }
}
```

**Purpose of Foreground Dispatch:**
- **Priority Handling**: Ensures your app receives NFC intents while in the foreground
- **Better User Experience**: Tags are handled immediately without system chooser dialogs
- **Activity Lifecycle**: Automatically enables dispatch on resume and disables on pause
- **Android 12+ Compatibility**: Uses `FLAG_MUTABLE` for PendingIntent on Android S (API 31) and above
- **Single Top Launch**: Prevents multiple activity instances when scanning tags

### iOS Configuration

**File:** `ios/Runner/Info.plist`

Add the following NFC configuration:

```xml
<!-- NFC Usage Description (Required for App Store) -->
<key>NFCReaderUsageDescription</key>
<string>This app uses NFC to read compatible NFC tags.</string>

<!-- ISO 7816 Select Identifiers (for ISO 14443 support) -->
<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
    <string>A0000000031010</string>
</array>

<!-- FeliCa System Codes (Required for ISO 18092 support) -->
<key>com.apple.developer.nfc.readersession.felica.systemcodes</key>
<array>
    <string>12FC</string>
    <string>FFFF</string>
</array>
```

**iOS Requirements:**
- `NFCReaderUsageDescription` is mandatory for App Store submission
- ISO 7816 identifiers must be declared for NFC reading
- FeliCa system codes are needed for Japanese cards and transit systems

## Implementation Details

### Controller (`nfc_scanner_controller.dart`)

Located at: `lib/nfc_scanner/services/nfc_scanner_controller.dart`

#### Initialization Flow

1. **Check NFC Availability:**
```dart
final isAvailable = await NfcManager.instance.isAvailable();
```

2. **Start NFC Session with Polling Options:**
```dart
NfcManager.instance.startSession(
  pollingOptions: {
    NfcPollingOption.iso15693,    // NFC-V (ISO 15693)
    NfcPollingOption.iso14443,    // NFC-A/B (ISO 14443)
    NfcPollingOption.iso18092,    // FeliCa (NFC-F)
  },
  onDiscovered: (NfcTag tag) async {
    // Process discovered tag
  },
);
```

3. **Automatic Cleanup:**
```dart
ref.onDispose(() {
  NfcManager.instance.stopSession();
});
```

#### Tag Reading Logic

The `_decodeTagType()` method extracts information from different tag technologies:

```dart
Map<String, String> _decodeTagType(NfcTag tag)
```

This method returns a map containing detailed tag information based on the detected technology.

### UI Components

#### NFC Scanner Screen (`nfc_scanner_screen.dart`)

The main screen uses pattern matching to display different UI states:

```dart
nfcState.when(
  checking: () => const NfcCheckingScreen(),
  unavailable: () => const NfcUnsupportedScreen(),
  disabled: () => const NfcTurnedOffScreen(),
  scanning: () => const NfcScanningScreen(),
  success: (details) => NfcSuccessScreen(details: details),
  error: (message) => NfcErrorScreen(error: message),
)
```

#### Scanning Animation (`nfc_scanning_screen.dart`)

Features:
- Custom painter showing phone with NFC area
- Animated NFC tag approaching the phone
- Pulsing effect on NFC area (2-second duration)
- Tag approach animation (3-second duration)
- Instruction text: "Place NFC tag at the back of your phone"

## Usage

### Navigation

The NFC scanner is accessible via the app router:

```dart
GoRoute(
  path: AppRoute.nfc.name,
  builder: (BuildContext context, GoRouterState state) {
    return const NfcScannerScanner();
  },
)
```

Navigate to `/nfc` route to access the scanner.

### Reading Tags

1. Navigate to the NFC scanner screen
2. The app automatically checks NFC availability
3. If NFC is available and enabled, scanning starts automatically
4. Place an NFC tag near the device's NFC antenna (usually at the back)
5. Tag details are displayed on success
6. Use "Try Again" button to scan another tag

## Supported NFC Technologies

The implementation can read from 8 different NFC tag technologies:

### 1. NFC-A (ISO 14443-A)
- **Common Use:** Credit cards, access cards, smartphones
- **Extracted Data:** UID, ATQA, SAK

### 2. NFC-B (ISO 14443-B)
- **Common Use:** Banking cards, secure access systems
- **Extracted Data:** UID, Application Data, Protocol Info

### 3. NFC-F (FeliCa - ISO 18092)
- **Common Use:** Japanese transit cards (Suica, PASMO)
- **Extracted Data:** UID, Manufacturer, System Code

### 4. NFC-V (ISO 15693)
- **Common Use:** Inventory systems, library books
- **Extracted Data:** UID, Response Flags, DSFID

### 5. MIFARE Classic
- **Common Use:** Legacy access cards, public transport
- **Extracted Data:** UID, Type, Memory Size, Block Count, Sector Count

### 6. MIFARE Ultralight
- **Common Use:** Low-cost disposable cards, event tickets
- **Extracted Data:** UID, Type

### 7. NDEF (NFC Data Exchange Format)
- **Common Use:** Smart posters, business cards, URLs
- **Extracted Data:** Support status, Writable flag, Max size, Type, Message availability

### 8. Generic Tag Information
- **Common Use:** Fallback for any tag
- **Extracted Data:** UID (hex format), UID length

## Troubleshooting

### NFC Not Available

**Symptoms:** App shows "NFC is not supported on this device"

**Solutions:**
- Verify the device has NFC hardware
- Check that platform configurations are correct (Android manifest, iOS Info.plist)

### NFC Disabled

**Symptoms:** App shows "NFC is turned off"

**Solutions:**
- Tap "Open NFC" button in the app to launch device settings
- Manually enable NFC in device settings:
  - **Android:** Settings → Connected devices → Connection preferences → NFC
  - **iOS:** NFC is always enabled on supported devices (iPhone 7+)

### Tag Not Detected

**Symptoms:** NFC is enabled but tags aren't being read

**Solutions:**
- Ensure the tag is placed at the back of the device
- Try different positions and angles
- Move the tag slowly closer to the device
- Remove any thick phone cases that might interfere
- Verify the tag is not damaged or protected

### iOS-Specific Issues

**Issue:** NFC not working on iOS

**Solutions:**
- Verify all Info.plist entries are correct
- Check that FeliCa system codes are declared
- Ensure `NFCReaderUsageDescription` is present
- Confirm device supports NFC (iPhone 7 or later)

### Android-Specific Issues

**Issue:** Permission denied

**Solutions:**
- Check that NFC permission is declared in AndroidManifest.xml
- Verify runtime permission handling (auto-granted for NFC)

## Code References

- Controller: `lib/nfc_scanner/services/nfc_scanner_controller.dart`
- Main Screen: `lib/nfc_scanner/presentation/nfc_scanner_screen.dart`
- State Definitions: `lib/nfc_scanner/domains/nfc_scanner_state.dart`
- Scanning Animation: `lib/nfc_scanner/presentation/nfc_screen_types/nfc_scanning_screen.dart`
- Router Configuration: `lib/router/router.dart`
- Android MainActivity: `android/app/src/main/kotlin/com/example/mobile_playground/MainActivity.kt`

## Future Enhancements

Potential improvements for the NFC implementation:

- [ ] NFC tag writing capability
- [ ] NDEF message parsing and display
- [ ] Tag history/logging
- [ ] Export tag data
- [ ] Custom NDEF record creation
- [ ] Peer-to-peer NFC communication
- [ ] Background tag reading (Android)
- [ ] Tag emulation (HCE - Host Card Emulation)

---

**Last Updated:** October 2025
