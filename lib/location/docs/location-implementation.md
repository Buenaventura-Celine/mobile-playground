# Location Feature Implementation

## Overview

The location feature provides an interactive map interface with real-time user location tracking, place search with autocomplete, and turn-by-turn directions rendering. The implementation uses Google Maps Platform APIs and follows a service-oriented architecture for better separation of concerns.

## Architecture

The location feature is organized into three main components:

```
lib/location/
├── location_screen.dart           # Main UI component
└── services/
    ├── location_service.dart      # Location & permission handling
    └── directions_service.dart    # Route calculation & rendering
```

### Component Responsibilities

- **LocationScreen** (`lib/location/location_screen.dart`): Main widget handling UI, user interactions, and coordinating between services
- **LocationService** (`lib/location/services/location_service.dart`): Manages device location access and permission requests
- **DirectionsService** (`lib/location/services/directions_service.dart`): Handles route calculation using Google Directions API

## Dependencies

The following packages are used for the location feature (from `pubspec.yaml`):

| Package | Version | Purpose |
|---------|---------|---------|
| `google_maps_flutter` | ^2.13.1 | Displays interactive Google Maps |
| `geolocator` | ^13.0.2 | Access device location and handle permissions |
| `geocoding` | ^3.0.0 | Convert addresses to coordinates |
| `google_places_flutter` | ^2.0.9 | Place search autocomplete UI |
| `flutter_polyline_points` | ^2.1.0 | Decode polyline for route rendering |
| `http` | ^1.2.2 | HTTP requests to Google Directions API |
| `flutter_dotenv` | ^5.2.1 | Environment variable management for API key |

## Configuration

### API Key Setup

The Google Maps API key is stored securely in a `.env` file:

```env
GOOGLE_MAPS_API_KEY=your_api_key_here
```

**Required API enablement:**
- Maps SDK for Android
- Maps SDK for iOS
- Directions API
- Places API
- Geocoding API

### Asset Configuration

In `pubspec.yaml`:

```yaml
assets:
  - .env
```

## Core Features

### 1. Current Location Detection

**Implementation**: `LocationService.getCurrentLocation()` (lib/location/services/location_service.dart:7)

**Flow:**
1. Check if location services are enabled on device
2. Check current permission status
3. Request permission if not granted
4. Get high-accuracy position with 10m distance filter
5. Return `LatLng` or `null` if denied

**Permission Handling:**
- `LocationPermission.denied` - Request permission
- `LocationPermission.deniedForever` - Return null (user must enable in settings)
- Service disabled - Return null

**Configuration:**
```dart
LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 10, // Update every 10 meters
)
```

### 2. Map Initialization

**Implementation**: `_LocationScreenState._initializeLocation()` (lib/location/location_screen.dart:35)

**Flow:**
1. Set loading state
2. Request current location from `LocationService`
3. If location obtained:
   - Update center position
   - Add "Current Location" marker
   - Animate camera to user's location (zoom level 15)
4. If permission denied:
   - Show snackbar notification
   - Add marker at default location (Portland, OR: 45.521563, -122.677433)
5. Clear loading state

### 3. Place Search with Autocomplete

**Implementation**: Google Places Autocomplete widget (lib/location/location_screen.dart:223)

**Features:**
- Real-time autocomplete suggestions
- Debounced search (400ms)
- Custom styled suggestion items
- Structured formatting (main text + secondary text)
- Latitude/longitude data included in results

**UI Components:**
- Search bar with floating design in app bar
- Icon-based suggestion items
- Clear button when text is present
- Custom box decoration with shadows

### 4. Route Directions

**Implementation**:
- `DirectionsService.getDirections()` (lib/location/services/directions_service.dart:10)
- `_LocationScreenState._searchAndShowDirections()` (lib/location/location_screen.dart:80)

**Flow:**
1. Geocode search query to coordinates
2. Request directions from Google Directions API
3. Decode polyline from API response
4. Render route on map with styled polyline
5. Add destination marker
6. Animate camera to fit entire route

**Route Styling:**
```dart
Polyline(
  color: Colors.blue,
  width: 5,
  patterns: [PatternItem.dot, PatternItem.gap(10)], // Dotted line
)
```

**Marker Styling:**
- Current location: Default red marker
- Destination: Azure blue marker

### 5. Camera Animation

**Implementation**: `_LocationScreenState._animateCameraToShowRoute()` (lib/location/location_screen.dart:153)

**Algorithm:**
1. Calculate bounding box from all route coordinates
2. Find min/max latitude and longitude
3. Create `LatLngBounds`
4. Animate camera to fit bounds with 100px padding

## User Interactions

### Search Flow
1. User types in search bar
2. Autocomplete suggestions appear (debounced 400ms)
3. User selects a location
4. App geocodes the address
5. Route is calculated and displayed
6. Camera animates to show full route

### Clear Route
**Trigger**: Click clear button (X icon)
**Actions**:
- Clear all polylines
- Remove destination marker (keeps current location marker)
- Clear search text field

## Error Handling

### Location Service Errors
- Service disabled → Return null, show notification
- Permission denied → Return null, show notification
- GPS error → Catch exception, return null

### Directions API Errors
- Network failure → Show error snackbar
- Invalid location → Show "Location not found" message
- API error response → Display error status and message
- Malformed response → Throw exception with details

## UI/UX Features

### Loading States
- Full-screen overlay with circular progress indicator
- Shown during:
  - Initial location fetch
  - Route calculation

### Notifications
- Snackbar messages for:
  - Permission requirements
  - Location errors
  - Route found confirmation
  - Search errors

### Styling
- Transparent app bar with floating search bar
- Material Design 3 color scheme
- Elevated search bar with multiple shadow layers
- Rounded corners (28px for search, 16px for suggestions)
- Custom icon containers with primary color theme

## Code Organization

### State Management
- StatefulWidget pattern
- Local state with `setState()`
- Private state variables with underscore prefix

### Key State Variables
```dart
LatLng _center                      // Current map center
Set<Marker> _markers                // Map markers
Set<Polyline> _polylines            // Route lines
bool _isLoading                     // Loading indicator
GoogleMapController mapController   // Map controller instance
```

### Controllers
```dart
TextEditingController _searchController  // Search input
DirectionsService _directionsService     // Route service
LocationService _locationService         // Location service
```

## Best Practices Implemented

1. **Separation of Concerns**: UI logic separated from business logic (services)
2. **Error Handling**: Try-catch blocks with user-friendly messages
3. **Permission Management**: Graceful degradation when permissions denied
4. **Resource Cleanup**: Controllers disposed in `dispose()` method
5. **API Key Security**: Environment variables instead of hardcoding
6. **User Feedback**: Loading states and informative snackbar messages
7. **Responsive UI**: Camera animations adapt to content
8. **Performance**: Debounced autocomplete to reduce API calls

## Future Enhancement Opportunities

- Turn-by-turn navigation instructions
- Route alternatives
- Traffic-aware routing
- Offline map caching
- Location tracking/history
- Custom map styling
- Distance and ETA display
- Multi-stop routing
- Voice-guided navigation
- Favorite locations
