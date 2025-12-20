import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../domain/document_scanner_state.dart';
import 'camera_service.dart';

/// Riverpod provider for the document scanner controller
/// Uses [autoDispose] to clean up resources when no longer watched
final documentScannerControllerProvider = NotifierProvider.autoDispose<
    DocumentScannerController,
    DocumentScannerState>(
  DocumentScannerController.new,
);

/// Main state management controller for the document scanner feature
///
/// Responsibilities:
/// - Manage camera permissions
/// - Orchestrate camera initialization
/// - Coordinate state transitions
/// - Handle resource cleanup
class DocumentScannerController extends Notifier<DocumentScannerState> {
  late List<CameraDescription> _cameras;
  late CameraService _cameraService;

  @override
  DocumentScannerState build() {
    _cameraService = CameraService();

    // Setup resource cleanup when this provider is no longer watched
    ref.onDispose(() {
      _cleanup();
    });

    // Start permission check immediately
    _checkPermissions();

    return const DocumentScannerState.checking();
  }

  /// Check camera permissions and initialize camera if granted
  Future<void> _checkPermissions() async {
    try {
      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        if (!ref.mounted) return;
        state = const DocumentScannerState.error('No cameras found on this device');
        return;
      }

      // Request camera permission
      final status = await Permission.camera.request();

      // Check if the widget is still mounted before updating state
      if (!ref.mounted) return;

      if (status.isGranted) {
        // Permission granted, initialize camera
        await _initializeCamera();
      } else if (status.isDenied) {
        state = const DocumentScannerState.error('Camera permission denied');
      } else if (status.isPermanentlyDenied) {
        state = const DocumentScannerState.error(
          'Camera permission permanently denied. Please enable it in app settings.',
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = DocumentScannerState.error('Failed to check camera: ${_formatError(e)}');
    }
  }

  /// Initialize the camera and emit ready state
  Future<void> _initializeCamera() async {
    try {
      if (_cameras.isEmpty) {
        state = const DocumentScannerState.error('No cameras available');
        return;
      }

      // Use first available camera (typically back camera)
      final selectedCamera = _cameras.first;

      if (!ref.mounted) return;

      // Emit ready state with default settings
      state = DocumentScannerState.ready(
        selectedCamera: selectedCamera,
        flashMode: FlashMode.auto,
        zoomLevel: 1.0,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = DocumentScannerState.error('Failed to initialize camera: ${_formatError(e)}');
    }
  }

  /// Capture an image from the camera
  Future<void> captureImage() async {
    // Only allow capture when camera is ready
    final canCapture = state.maybeWhen(
      ready: (_, __, ___) => true,
      orElse: () => false,
    );

    if (!canCapture) {
      return;
    }

    state = const DocumentScannerState.capturing();

    try {
      if (!_cameraService.isInitialized) {
        throw Exception('Camera not initialized');
      }

      final imageFile = await _cameraService.captureImage();

      if (!ref.mounted) return;

      // Emit preview state with captured image
      state = DocumentScannerState.preview(imageFile);
    } catch (e) {
      if (!ref.mounted) return;
      state = DocumentScannerState.error('Failed to capture image: ${_formatError(e)}');
    }
  }

  /// Set flash mode (auto, on, off, torch)
  Future<void> setFlashMode(FlashMode mode) async {
    try {
      if (!_cameraService.isInitialized) {
        throw Exception('Camera not initialized');
      }

      await _cameraService.setFlashMode(mode);

      if (!ref.mounted) return;

      // Update state with new flash mode if in ready state
      state = state.maybeWhen(
        ready: (camera, _, zoom) => DocumentScannerState.ready(
          selectedCamera: camera,
          flashMode: mode,
          zoomLevel: zoom,
        ),
        orElse: () => state,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = DocumentScannerState.error('Failed to set flash: ${_formatError(e)}');
    }
  }

  /// Set zoom level
  Future<void> setZoom(double zoom) async {
    try {
      if (!_cameraService.isInitialized) {
        throw Exception('Camera not initialized');
      }

      await _cameraService.setZoom(zoom);

      if (!ref.mounted) return;

      // Update state with new zoom level if in ready state
      state = state.maybeWhen(
        ready: (camera, flashMode, _) => DocumentScannerState.ready(
          selectedCamera: camera,
          flashMode: flashMode,
          zoomLevel: zoom,
        ),
        orElse: () => state,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = DocumentScannerState.error('Failed to set zoom: ${_formatError(e)}');
    }
  }

  /// Switch to a different camera (front/back)
  Future<void> switchCamera(CameraDescription camera) async {
    try {
      await _cameraService.switchCamera(camera);

      if (!ref.mounted) return;

      // Update state with new camera
      state = state.maybeWhen(
        ready: (_, flashMode, zoom) => DocumentScannerState.ready(
          selectedCamera: camera,
          flashMode: flashMode,
          zoomLevel: zoom,
        ),
        orElse: () => state,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = DocumentScannerState.error('Failed to switch camera: ${_formatError(e)}');
    }
  }

  /// Clean up resources when disposing
  Future<void> _cleanup() async {
    await _cameraService.dispose();
  }

  /// Format error messages for user display
  String _formatError(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }
}
