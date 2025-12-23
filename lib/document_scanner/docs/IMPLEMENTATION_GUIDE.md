# Document Scanner - Technical Implementation Guide

## Overview

This guide provides step-by-step instructions for refactoring the monolithic `document_scanner.dart` into a clean, layered architecture following the NFC Scanner pattern. The implementation is broken into 6 small, validatable phases.

## Architecture Overview

```
lib/document_scanner/
├── domain/                              # Business models (Freezed)
│   ├── document_scanner_state.dart
│   └── document_scanner_state.freezed.dart
├── presentation/                        # UI Layer
│   ├── document_scanner_screen.dart      # Main router
│   ├── document_screen_template.dart     # Reusable base
│   └── screens/
│       ├── camera_preview_screen.dart
│       ├── capture_mode_screen.dart
│       ├── preview_screen.dart
│       ├── gallery_screen.dart
│       └── error_screen.dart
├── services/                            # Application Logic Layer
│   ├── document_scanner_controller.dart  # State management + Orchestration
│   └── camera_service.dart              # Camera hardware operations
├── data/                                # Data Access Layer
│   ├── repositories/
│   │   └── document_repository.dart      # Coordinate file operations
│   └── datasources/
│       └── file_datasource.dart         # File system read/write operations
└── docs/
    ├── feature_specification.md
    └── IMPLEMENTATION_GUIDE.md
```

## Data Flow

```
User Action (Button Click)
    ↓
Presentation Widget calls controller method
    ↓
DocumentScannerController orchestrates logic
    ↓
Uses: CameraService (for camera ops) + DocumentRepository (for file ops)
    ↓
CameraService: Hardware operations    DocumentRepository: File I/O operations
(Camera control, capture)              (Read/write/delete files)
    ↓                                  ↓
CameraController                       FileDataSource
    ↓
State updates, Riverpod notifies listeners
    ↓
UI rebuilds via .when() pattern matching
```

**Layer Responsibilities:**
- **Presentation:** UI rendering, user interactions
- **Services:** Orchestration, state management (Controller) + hardware operations (CameraService)
- **Data:** File system operations (Repository → FileDataSource)

## State Diagram

```
checking
    ↓
ready ←→ capturing → preview
    ↓        ↓
  error ←───┘
```

**State Definitions:**
- `checking()` - Validating permissions and initializing camera
- `ready()` - Camera initialized, ready for capture
- `capturing()` - Picture/video capture in progress
- `preview(XFile imageFile)` - Captured image displayed for confirmation
- `processing()` - Image processing (ML Kit, enhancement)
- `error(String message)` - Error occurred during any operation

---

## Phase 1: Domain Layer & State Management

**Duration:** ~30 minutes
**Deliverables:** State types + Controller foundation
**Dependencies:** None (new feature)

### Step 1.1: Create Domain State Types

**File:** `lib/document_scanner/domain/document_scanner_state.dart`

Create Freezed sealed union types for all possible states. Pattern reference: `lib/nfc_scanner/domains/nfc_scanner_state.dart`

**What to include:**
```dart
@freezed
class DocumentScannerState with _$DocumentScannerState {
  const factory DocumentScannerState.checking() = _Checking;
  const factory DocumentScannerState.ready({
    required CameraDescription selectedCamera,
    required FlashMode flashMode,
    required double zoomLevel,
  }) = _Ready;
  const factory DocumentScannerState.capturing() = _Capturing;
  const factory DocumentScannerState.preview(XFile imageFile) = _Preview;
  const factory DocumentScannerState.processing() = _Processing;
  const factory DocumentScannerState.error(String message) = _Error;
}
```

**Key Points:**
- Use `@freezed` for immutability
- Include all metadata needed by UI (flashMode, zoomLevel, etc.)
- Run `flutter pub run build_runner build` to generate `.freezed.dart`

### Step 1.2: Create Controller Foundation

**File:** `lib/document_scanner/services/document_scanner_controller.dart`

Create the main state management controller extending `Notifier`.

**What to include:**
```dart
final documentScannerControllerProvider =
    NotifierProvider.autoDispose<
      DocumentScannerController,
      DocumentScannerState
    >(
      DocumentScannerController.new,
    );

class DocumentScannerController extends Notifier<DocumentScannerState> {
  CameraController? _cameraController;

  @override
  DocumentScannerState build() {
    // Setup cleanup
    ref.onDispose(() {
      _cameraController?.dispose();
    });

    // Start permission check
    _checkPermissions();

    return const DocumentScannerState.checking();
  }

  Future<void> _checkPermissions() async {
    // Request camera permission
    // Initialize camera if granted
    // Emit appropriate state
  }

  Future<void> _initializeCamera() async {
    // Set up camera controller
    // Emit ready state
  }
}
```

**Key Points:**
- `autoDispose` cleans up unused resources
- `ref.onDispose()` handles cleanup of camera
- Use `ref.mounted` checks for async safety
- All state changes go through `state = ...`

### Step 1.3: Validation Checklist

After implementing Phase 1, verify:

- [ ] `document_scanner_state.dart` compiles without errors
- [ ] Run `flutter pub run build_runner build` successfully generates `.freezed.dart`
- [ ] `DocumentScannerController` can be instantiated
- [ ] Provider is accessible via `ref.watch(documentScannerControllerProvider)`
- [ ] No UI/presentation code in controller
- [ ] All async operations have `ref.mounted` guards (if added)

---

## Phase 2: Basic Camera Capture Logic

**Duration:** ~1 hour
**Deliverables:** Camera service + Capture functionality
**Dependencies:** Phase 1 complete

### Step 2.1: Create Camera Service

**File:** `lib/document_scanner/services/camera_service.dart`

Encapsulate all camera hardware operations in the Application Layer (Services).

**What to include:**
```dart
class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  Future<void> initCamera(CameraDescription camera) async {
    // Initialize camera controller
    // Set up callbacks
    // Start preview
  }

  Future<XFile> captureImage() async {
    // Take picture and return XFile
  }

  Future<void> setFlashMode(FlashMode mode) async {
    // Update flash mode
  }

  Future<void> setZoom(double zoom) async {
    // Clamp and set zoom level
  }

  Future<void> switchCamera(CameraDescription camera) async {
    // Switch between front/back cameras
  }

  void dispose() {
    // Clean up camera controller
    _controller?.dispose();
  }

  // Getters for current state
  double get minZoom => _controller?.minAvailableZoom ?? 1.0;
  double get maxZoom => _controller?.maxAvailableZoom ?? 1.0;
  CameraController? get controller => _controller;
}
```

**Key Points:**
- Lives in **services** folder (Application Layer)
- Encapsulate all camera implementation details
- Handle exceptions and convert to user-friendly messages
- Provide getters for zoom limits, current camera, etc.
- No state emission here (that's the controller's job)
- No file I/O operations (that's FileDataSource in Data Layer)

### Step 2.2: Update Controller with Capture Logic

**File:** `lib/document_scanner/services/document_scanner_controller.dart` (update)

Add capture methods to controller using the camera service.

**What to add:**
```dart
class DocumentScannerController extends Notifier<DocumentScannerState> {
  late CameraService _cameraService;
  List<CameraDescription> _cameras = [];

  Future<void> captureImage() async {
    if (state is! _Ready) return;

    state = const DocumentScannerState.capturing();

    try {
      final imageFile = await _cameraService.captureImage();
      state = DocumentScannerState.preview(imageFile);
    } catch (e) {
      state = DocumentScannerState.error(_formatError(e));
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    await _cameraService.setFlashMode(mode);

    // Update state with new flash mode
    if (state is _Ready) {
      final ready = state as _Ready;
      state = ready.copyWith(flashMode: mode);
    }
  }

  Future<void> setZoom(double zoom) async {
    await _cameraService.setZoom(zoom);

    if (state is _Ready) {
      final ready = state as _Ready;
      state = ready.copyWith(zoomLevel: zoom);
    }
  }
}
```

**Key Points:**
- Check current state before proceeding
- Update state after each operation
- Catch exceptions and emit error state
- Use `copyWith()` to update state immutably

### Step 2.3: Validation Checklist

After implementing Phase 2, verify:

- [ ] `CameraService` compiles without errors
- [ ] Can capture an image and emit preview state
- [ ] Flash mode switching updates state correctly
- [ ] Zoom controls work smoothly
- [ ] Error messages display for permission denials
- [ ] Camera controller disposes properly on controller disposal
- [ ] No UI code mixed with capture logic
- [ ] CameraService lives in `/services` folder (not data layer)

---

## Phase 3: File Management & Storage

**Duration:** ~45 minutes
**Deliverables:** File datasource + File-only repository layer
**Dependencies:** Phase 1 complete

### Step 3.1: Create File Datasource

**File:** `lib/document_scanner/data/datasources/file_datasource.dart`

Handle all file system operations.

**What to include:**
```dart
class FileDataSource {
  Future<String> saveImageToTemp(XFile image) async {
    // Copy image to temporary directory
    // Return path to temporary file
  }

  Future<String> moveToApplicationDocuments(String tempPath) async {
    // Move from temp to app documents directory
    // Rename with timestamp or UUID
    // Return new path
  }

  Future<void> deleteImage(String filePath) async {
    // Delete file from app documents
    // Handle not found errors gracefully
  }

  Future<List<String>> getDocumentList() async {
    // List all saved document files
    // Sort by creation time (newest first)
    // Return list of file paths
  }

  Future<String> getApplicationDocumentsPath() async {
    // Get app's documents directory
    return (await getApplicationDocumentsDirectory()).path;
  }
}
```

**Key Points:**
- Use `path_provider` for directory paths
- Handle file not found and permission errors
- Implement file lifecycle: temp → documents
- Return paths as strings for flexibility

### Step 3.2: Create Document Repository

**File:** `lib/document_scanner/data/repositories/document_repository.dart`

Coordinate file datasource operations.

**What to include:**
```dart
class DocumentRepository {
  final FileDataSource _fileDataSource;

  DocumentRepository({
    required FileDataSource fileDataSource,
  }) : _fileDataSource = fileDataSource;

  Future<String> saveImageToTemp(XFile image) async {
    // 1. Save captured image to temp
    return await _fileDataSource.saveImageToTemp(image);
  }

  Future<String> moveToApplicationDocuments(String tempPath) async {
    // 2. Move from temp to permanent storage
    return await _fileDataSource.moveToApplicationDocuments(tempPath);
  }

  Future<void> deleteDocument(String filePath) async {
    // Delete file from app documents
    await _fileDataSource.deleteImage(filePath);
  }

  Future<List<String>> getDocumentList() async {
    // Get list of all saved documents
    return await _fileDataSource.getDocumentList();
  }
}
```

**Key Points:**
- Repository **only** orchestrates file operations (Data Layer)
- **Camera operations** are handled directly by CameraService in controller
- Single responsibility: coordinate file I/O, don't implement it
- Return file paths for UI to display
- Let exceptions bubble up for controller to handle

### Step 3.3: Create Repository Provider

Add to `document_scanner_controller.dart`:

```dart
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final fileDataSource = FileDataSource();
  return DocumentRepository(
    fileDataSource: fileDataSource,
  );
});
```

### Step 3.4: Validation Checklist

After implementing Phase 3, verify:

- [ ] Images save to app documents directory
- [ ] Temporary files are cleaned up
- [ ] Can list saved documents
- [ ] File deletion works
- [ ] Error handling for permission denied
- [ ] File paths are valid and accessible

---

## Phase 4: Presentation Layer - Main Router & Template

**Duration:** ~1 hour
**Deliverables:** Main screen router + Reusable template
**Dependencies:** Phase 1, 2, 3 complete

### Step 4.1: Create Main Router Screen

**File:** `lib/document_scanner/presentation/document_scanner_screen.dart`

Entry point widget that routes states to appropriate screens.

**What to include:**
```dart
class DocumentScannerScreen extends ConsumerWidget {
  const DocumentScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(documentScannerControllerProvider);

    return state.when(
      checking: () => const _CheckingScreen(),
      ready: (camera, flashMode, zoom) =>
        _CameraPreviewScreen(
          camera: camera,
          flashMode: flashMode,
          zoom: zoom,
        ),
      capturing: () => const _CapturingScreen(),
      preview: (imageFile) => _PreviewScreen(imageFile: imageFile),
      processing: () => const _ProcessingScreen(),
      error: (message) => _ErrorScreen(message: message),
    );
  }
}

class _CheckingScreen extends StatelessWidget {
  const _CheckingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Checking permissions...'),
          ],
        ),
      ),
    );
  }
}
```

**Key Points:**
- Watch the controller provider for state changes
- Use `.when()` for exhaustive state matching
- Create simple placeholder screens for each state
- Callbacks will call controller methods

### Step 4.2: Create Reusable Screen Template

**File:** `lib/document_scanner/presentation/document_screen_template.dart`

Reference: `lib/nfc_scanner/presentation/nfc_screen.dart`

**What to include:**
```dart
class DocumentScreenTemplate extends ConsumerWidget {
  final List<Color> backgroundColors;
  final Color primaryColor;
  final Widget? header;
  final Widget body;
  final List<Widget>? actionButtons;
  final VoidCallback? onDismiss;

  const DocumentScreenTemplate({
    required this.backgroundColors,
    required this.primaryColor,
    this.header,
    required this.body,
    this.actionButtons,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (header != null) ...[
                header!,
                SizedBox(height: 32),
              ],
              body,
              if (actionButtons != null) ...[
                SizedBox(height: 24),
                ...actionButtons!,
              ],
              if (onDismiss != null) ...[
                SizedBox(height: 16),
                TextButton(
                  onPressed: onDismiss,
                  child: Text('Cancel'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

**Key Points:**
- Provides consistent layout across all state screens
- Supports optional header, body, and action buttons
- Uses gradient background for visual appeal
- Reusable for future features

### Step 4.3: Validation Checklist

After implementing Phase 4, verify:

- [ ] Main router compiles and displays
- [ ] State transitions update screen correctly
- [ ] Template layout renders without overflow
- [ ] Buttons are clickable (even if non-functional)
- [ ] All 6 states have at least a placeholder screen
- [ ] No business logic in presentation widgets

---

## Phase 5: Presentation Layer - State Screens

**Duration:** ~2 hours
**Deliverables:** Fully functional UI screens
**Dependencies:** Phase 1-4 complete

### Step 5.1: Camera Preview Screen

**File:** `lib/document_scanner/presentation/screens/camera_preview_screen.dart`

Live camera feed with controls.

**Key Features:**
- Live preview using `CameraPreview()`
- Gesture handling:
  - Pinch-to-zoom
  - Tap-to-focus
- Flash, zoom, camera toggle buttons
- Capture button
- Callbacks to controller

### Step 5.2: Preview/Confirmation Screen

**File:** `lib/document_scanner/presentation/screens/preview_screen.dart`

Show captured image for user confirmation.

**Key Features:**
- Display captured image
- Confirm and Retake buttons
- Optional: rotate/crop controls
- Navigate back to camera on Retake
- Save on Confirm

### Step 5.3: Gallery Screen

**File:** `lib/document_scanner/presentation/screens/gallery_screen.dart`

List of saved documents.

**Key Features:**
- Grid/list of saved images
- Thumbnails with metadata
- Delete option
- Optional: Share integration
- Pull-to-refresh

### Step 5.4: Error Screen

**File:** `lib/document_scanner/presentation/screens/error_screen.dart`

Display errors with retry option.

**Key Features:**
- Error icon/message
- Descriptive error text
- Retry button
- Back/Close button

### Step 5.5: Additional Screens (Optional for Phase 5)

- **Capturing Screen:** Loading state with animation
- **Processing Screen:** ML Kit processing feedback

### Step 5.6: Validation Checklist

After implementing Phase 5, verify:

- [ ] All screens render without crashes
- [ ] Images display correctly in preview
- [ ] Buttons trigger correct callbacks
- [ ] Camera preview is smooth and responsive
- [ ] Gallery loads and displays saved images
- [ ] Error messages are clear and helpful

---

## Phase 6: Integration & Cleanup

**Duration:** ~30 minutes
**Deliverables:** Full working feature
**Dependencies:** Phases 1-5 complete

### Step 6.1: Update App Routing

**File:** `lib/main.dart` (or your app routing file)

Replace old document scanner import:

```dart
// OLD
import 'package:mobile_playground/document_scanner/document_scanner.dart';

// NEW
import 'package:mobile_playground/document_scanner/presentation/document_scanner_screen.dart';

// In your router/navigation:
// DocumentScannerScreen() // instead of DocumentScanner()
```

### Step 6.2: Verify Dependencies

Check that all required packages are in `pubspec.yaml`:
- `riverpod`
- `flutter_riverpod`
- `freezed_annotation`
- `camera`
- `path_provider`
- `image` (if still needed)

Run:
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 6.3: Remove Old Code

**Delete:**
- `lib/document_scanner/document_scanner.dart`

**Keep:**
- `lib/document_scanner/docs/feature_specification.md`
- `lib/document_scanner/docs/IMPLEMENTATION_GUIDE.md`

### Step 6.4: Run Tests

```bash
flutter pub run build_runner build
flutter analyze
flutter format lib/document_scanner/
```

### Step 6.5: End-to-End Testing

Manual test flow:
1. [ ] App launches without errors
2. [ ] Camera permission prompts
3. [ ] Can navigate to scanner
4. [ ] Can capture image
5. [ ] Can save image
6. [ ] Can view gallery
7. [ ] Can delete images
8. [ ] Error handling works
9. [ ] No crashes during any flow

### Step 6.6: Code Review Checklist

- [ ] Follows NFC Scanner patterns
- [ ] No monolithic files (max 300 lines per file)
- [ ] All layer responsibilities respected
- [ ] Error handling comprehensive
- [ ] Resource cleanup in place
- [ ] Documentation updated
- [ ] No debug prints or commented code

---

## Common Issues & Solutions

### Issue: "ref.mounted is not available"
**Solution:** Ensure you're using Riverpod 2.0+. Check in async methods:
```dart
Future<void> myMethod() async {
  state = const Loading();

  try {
    final result = await someAsyncOperation();

    // Check before updating state
    if (!ref.mounted) return;

    state = Success(result);
  } catch (e) {
    if (!ref.mounted) return;
    state = Error(e.toString());
  }
}
```

### Issue: "CameraController not initialized"
**Solution:** Ensure camera is fully initialized in CameraService before use:
```dart
// In CameraService
Future<void> initCamera(CameraDescription camera) async {
  _controller = CameraController(camera, ResolutionPreset.high);
  await _controller!.initialize(); // <-- Important!
  await _controller!.startImageStream((image) {}); // Start preview
}
```

### Issue: "Files not persisting"
**Solution:** Use `getApplicationDocumentsDirectory()` from `path_provider`:
```dart
import 'package:path_provider/path_provider.dart';

final dir = await getApplicationDocumentsDirectory();
final filePath = '${dir.path}/image_${timestamp}.jpg';
```

### Issue: "State not updating in UI"
**Solution:** Ensure state is immutable. Don't modify in place:
```dart
// WRONG
state.flashMode = FlashMode.on; // mutation!

// RIGHT
state = state.copyWith(flashMode: FlashMode.on);
// OR for sealed classes:
state = state.maybeWhen(
  ready: (camera, _, zoom) => DocumentScannerState.ready(
    selectedCamera: camera,
    flashMode: FlashMode.on,
    zoomLevel: zoom,
  ),
  orElse: () => state,
);
```

---

---

## Phase 7: Document Processing - Detection, Correction & Enhancement

**Duration:** ~3 hours
**Deliverables:** Document detection, perspective correction, image enhancement services, visual frame guide
**Dependencies:** Phases 1-6 complete
**Status:** ✅ COMPLETE

This phase transforms the app from a basic camera into a true document scanner by adding intelligent document processing capabilities.

### What Was Implemented
- ✅ Document detection (edge detection + corner finding)
- ✅ Perspective correction (cropping to detected corners)
- ✅ Image enhancement (contrast + normalization)
- ✅ Frame guide (visual overlay with corner markers)

### Step 7.1: Create Document Detection Service

**File:** `lib/document_scanner/services/document_detection_service.dart`

Detect document boundaries (corners/edges) in images using edge detection.

**What to include:**
```dart
import 'package:image/image.dart' as img;

class DocumentDetectionService {
  /// Detect document corners in an image
  /// Returns list of corner coordinates (top-left, top-right, bottom-right, bottom-left)
  Future<List<Offset>?> detectDocumentCorners(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) return null;

      // Convert to grayscale
      final gray = _toGrayscale(image);

      // Apply Canny edge detection
      final edges = _cannyEdgeDetection(gray);

      // Find contours and detect document shape
      final corners = _findDocumentCorners(edges, image.width, image.height);

      return corners;
    } catch (e) {
      throw Exception('Failed to detect document corners: $e');
    }
  }

  /// Check if image contains a valid document (area > threshold)
  bool _isValidDocument(List<Offset> corners) {
    if (corners.length != 4) return false;

    // Calculate area using cross product
    final area = _calculatePolygonArea(corners);
    const minArea = 10000; // Minimum area threshold

    return area > minArea;
  }

  // Helper methods...
  List<int> _toGrayscale(img.Image image) {
    // Implementation
  }

  List<int> _cannyEdgeDetection(List<int> gray) {
    // Implementation
  }

  List<Offset> _findDocumentCorners(List<int> edges, int width, int height) {
    // Implementation
  }

  double _calculatePolygonArea(List<Offset> points) {
    // Implementation
  }
}
```

**Key Points:**
- Detect 4 corners of documents in images
- Return corner coordinates as Offset points
- Handle various document sizes and angles
- Gracefully fail for images without documents

### Step 7.2: Create Perspective Correction Service

**File:** `lib/document_scanner/services/perspective_correction_service.dart`

Transform skewed document images to be straight and readable.

**What to include:**
```dart
import 'package:image/image.dart' as img;

class PerspectiveCorrectionService {
  /// Apply perspective transform to straighten document
  /// Returns corrected image file path
  Future<String> correctPerspective({
    required String imagePath,
    required List<Offset> corners,
    int? outputWidth,
    int? outputHeight,
  }) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('Could not decode image');

      // Apply perspective transform using corners
      final corrected = _applyPerspectiveTransform(
        image,
        corners,
        outputWidth ?? image.width,
        outputHeight ?? image.height,
      );

      // Save corrected image
      final correctedPath = _getSavePathForCorrected(imagePath);
      await File(correctedPath).writeAsBytes(img.encodePng(corrected));

      return correctedPath;
    } catch (e) {
      throw Exception('Failed to correct perspective: $e');
    }
  }

  /// Apply 4-point perspective transform
  img.Image _applyPerspectiveTransform(
    img.Image image,
    List<Offset> corners,
    int outputWidth,
    int outputHeight,
  ) {
    // Use inverse warping or similar algorithm
    // Implementation
  }

  String _getSavePathForCorrected(String originalPath) {
    // Return path with "_corrected" suffix
  }
}
```

**Key Points:**
- Takes detected corners and transforms the image
- Straightens skewed/angled document photos
- Maintains document aspect ratio
- Returns new corrected image path

### Step 7.3: Create Image Enhancement Service

**File:** `lib/document_scanner/services/image_enhancement_service.dart`

Improve image quality for better OCR and readability.

**What to include:**
```dart
import 'package:image/image.dart' as img;

class ImageEnhancementService {
  /// Enhance image for better readability
  /// Adjusts contrast, brightness, and applies sharpening
  Future<String> enhanceImage(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      var image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('Could not decode image');

      // Apply enhancements sequentially
      image = _adjustContrast(image, 1.2);
      image = _adjustBrightness(image, 1.1);
      image = _sharpen(image);
      image = _reduceNoise(image);

      // Save enhanced image
      final enhancedPath = _getSavePathForEnhanced(imagePath);
      await File(enhancedPath).writeAsBytes(img.encodePng(image));

      return enhancedPath;
    } catch (e) {
      throw Exception('Failed to enhance image: $e');
    }
  }

  /// Increase contrast to make text pop
  img.Image _adjustContrast(img.Image image, double factor) {
    // Implementation
  }

  /// Adjust brightness
  img.Image _adjustBrightness(img.Image image, double factor) {
    // Implementation
  }

  /// Apply unsharp mask for sharpness
  img.Image _sharpen(img.Image image) {
    // Implementation
  }

  /// Reduce noise while preserving edges
  img.Image _reduceNoise(img.Image image) {
    // Bilateral filter or similar
    // Implementation
  }

  String _getSavePathForEnhanced(String originalPath) {
    // Return path with "_enhanced" suffix
  }
}
```

**Key Points:**
- Improve document image quality
- Enhance contrast for text recognition
- Apply sharpening filters
- Reduce noise and artifacts
- Returns enhanced image path

### Step 7.4: Update Controller for Document Processing

**File:** `lib/document_scanner/services/document_scanner_controller.dart` (update)

Add document processing to the capture flow.

**Add these to the controller:**
```dart
class DocumentScannerController extends Notifier<DocumentScannerState> {
  late DocumentDetectionService _detectionService;
  late PerspectiveCorrectionService _correctionService;
  late ImageEnhancementService _enhancementService;

  @override
  DocumentScannerState build() {
    // ... existing code ...

    _detectionService = DocumentDetectionService();
    _correctionService = PerspectiveCorrectionService();
    _enhancementService = ImageEnhancementService();

    ref.onDispose(() {
      _cleanup();
    });

    return const DocumentScannerState.checking();
  }

  Future<void> captureImage() async {
    // Existing capture code...
    state = const DocumentScannerState.capturing();

    try {
      final imageFile = await _cameraService.captureImage();

      // NEW: Process document
      state = const DocumentScannerState.processing();
      final processedPath = await _processDocument(imageFile.path);

      if (!ref.mounted) return;

      // Use processed image in preview
      state = DocumentScannerState.preview(XFile(processedPath));
    } catch (e) {
      if (!ref.mounted) return;
      state = DocumentScannerState.error('Failed to capture image: ${_formatError(e)}');
    }
  }

  /// Process document: detect → correct → enhance
  Future<String> _processDocument(String imagePath) async {
    try {
      // Step 1: Detect document corners
      final corners = await _detectionService.detectDocumentCorners(imagePath);

      String processedPath = imagePath;

      // Step 2: Correct perspective if document detected
      if (corners != null && corners.length == 4) {
        processedPath = await _correctionService.correctPerspective(
          imagePath: processedPath,
          corners: corners,
        );
      }

      // Step 3: Enhance image for readability
      processedPath = await _enhancementService.enhanceImage(processedPath);

      return processedPath;
    } catch (e) {
      // If processing fails, return original image
      return imagePath;
    }
  }
}
```

**Key Points:**
- Document processing happens after capture
- Shows `processing()` state during enhancement
- Gracefully handles failures (returns original image)
- Services are created once in `build()`
- Processing runs before preview display

### Step 7.5: Update Camera Preview for Document Guides

**File:** `lib/document_scanner/presentation/screens/camera_preview_screen.dart` (update)

Add visual guide for proper document positioning.

**Add frame guide overlay:**
```dart
class _DocumentFrameGuide extends StatelessWidget {
  const _DocumentFrameGuide();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DocumentFramePainter(),
      size: Size.infinite,
    );
  }
}

class DocumentFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw corner markers
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw frame outline with rounded corners
    final rect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.2,
      size.width * 0.8,
      size.height * 0.6,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(8)),
      paint,
    );

    // Draw corner guides
    final cornerSize = 40.0;
    final corners = [
      rect.topLeft,
      rect.topRight,
      rect.bottomRight,
      rect.bottomLeft,
    ];

    for (final corner in corners) {
      canvas.drawCircle(corner, 6, paint);
    }
  }

  @override
  bool shouldRepaint(DocumentFramePainter oldDelegate) => false;
}
```

**Add to camera preview:**
```dart
Stack(
  children: [
    CameraPreview(_cameraController),
    // Add frame guide
    const _DocumentFrameGuide(),
    // Rest of controls...
  ],
)
```

### Step 7.6: Update Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  image: ^4.0.0
  opencv_dart: ^1.0.0  # Optional: for advanced edge detection
```

Run:
```bash
flutter pub get
```

### Step 7.7: Validation Checklist

After implementing Phase 7, verify:

- [ ] Document detection works on various document angles
- [ ] Perspective correction straightens skewed documents
- [ ] Image enhancement improves contrast/sharpness
- [ ] Frame guide appears on camera preview
- [ ] Processing state shows during enhancement
- [ ] App gracefully handles edge cases (no document detected)
- [ ] Original image returned if processing fails
- [ ] Performance acceptable (processing < 2 seconds)
- [ ] Memory usage doesn't spike during processing

---

## Next Steps After Phase 7

Once document processing is complete:

### Phase 8: Advanced Export (Optional)
- PDF generation using `pdf` package
- JPEG quality controls
- Multi-page document support
- Compression options

### Phase 9: Performance & Polish (Optional)
- Image caching
- Thumbnail generation
- Batch operations
- Offline sync support

### Phase 10: ML Kit Integration (Optional)
- OCR using `google_ml_kit`
- Extract text from documents
- Auto-categorize documents

---

## References

- **NFC Scanner Implementation:** `lib/nfc_scanner/` (reference architecture)
- **Architecture Documentation:** `docs/ARCHITECTURE.md`
- **Feature Specification:** `lib/document_scanner/docs/feature_specification.md`
- **Riverpod Docs:** https://riverpod.dev
- **Flutter Camera Package:** https://pub.dev/packages/camera
- **Freezed Package:** https://pub.dev/packages/freezed_annotation
