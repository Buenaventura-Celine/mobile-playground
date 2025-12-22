import 'package:camera/camera.dart';

/// Service for handling all camera hardware operations.
/// Lives in the Application Layer (Services).
///
/// Responsibilities:
/// - Initialize and manage CameraController
/// - Handle camera capture operations
/// - Manage flash, zoom, and focus settings
/// - Provide hardware capability information (min/max zoom)
///
/// This service encapsulates all camera implementation details and provides
/// a clean interface for the controller to use.
class CameraService {
  CameraController? _controller;
  FlashMode _currentFlashMode = FlashMode.auto;
  double _currentZoom = 1.0;

  /// Initialize camera with the given camera description
  Future<void> initCamera(CameraDescription camera) async {
    try {
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      // Set default values
      _currentFlashMode = FlashMode.auto;
      _currentZoom = 1.0;
    } catch (e) {
      _controller = null;
      rethrow;
    }
  }

  /// Capture an image and return it as XFile
  Future<XFile> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    if (_controller!.value.isTakingPicture) {
      throw Exception('Camera is already taking a picture');
    }

    try {
      final image = await _controller!.takePicture();
      return image;
    } catch (e) {
      throw Exception('Failed to capture image: $e');
    }
  }

  /// Set flash mode (auto, on, off, torch)
  Future<void> setFlashMode(FlashMode mode) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      await _controller!.setFlashMode(mode);
      _currentFlashMode = mode;
    } catch (e) {
      throw Exception('Failed to set flash mode: $e');
    }
  }

  /// Set zoom level (between minZoom and maxZoom)
  Future<void> setZoom(double zoom) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      // Clamp zoom to valid range
      final clampedZoom = zoom.clamp(minZoom, maxZoom);
      await _controller!.setZoomLevel(clampedZoom);
      _currentZoom = clampedZoom;
    } catch (e) {
      throw Exception('Failed to set zoom: $e');
    }
  }

  /// Switch to a different camera
  Future<void> switchCamera(CameraDescription camera) async {
    try {
      // Dispose current controller
      await _controller?.dispose();

      // Initialize new camera
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      // Restore previous settings
      await setFlashMode(_currentFlashMode);
      await setZoom(_currentZoom);
    } catch (e) {
      _controller = null;
      throw Exception('Failed to switch camera: $e');
    }
  }

  /// Dispose camera resources
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }

  /// Get the underlying CameraController widget
  CameraController? get controller => _controller;

  /// Check if a controller exists and is initialized
  bool get hasInitializedCamera => _controller != null && _controller!.value.isInitialized;

  /// Get minimum available zoom level
  double get minZoom => 1.0; // Camera typically starts at 1.0x zoom

  /// Get maximum available zoom level
  /// Note: Camera package may not expose max zoom, so we use a reasonable default
  double get maxZoom => 5.0; // Most phones support up to 5x zoom

  /// Get current zoom level
  double get currentZoom => _currentZoom;

  /// Get current flash mode
  FlashMode get currentFlashMode => _currentFlashMode;

  /// Check if camera is initialized and ready
  bool get isInitialized => _controller != null && _controller!.value.isInitialized;
}
