import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_scanner_state.freezed.dart';

/// Domain state representing the current state of the document scanner feature.
/// Uses Freezed for immutability and sealed union types for exhaustive pattern matching.
@freezed
class DocumentScannerState with _$DocumentScannerState {
  /// Initial state: checking camera permissions and availability
  const factory DocumentScannerState.checking() = _Checking;

  /// Camera is ready for use, can capture images
  const factory DocumentScannerState.ready({
    required CameraDescription selectedCamera,
    required FlashMode flashMode,
    required double zoomLevel,
  }) = _Ready;

  /// Currently capturing an image
  const factory DocumentScannerState.capturing() = _Capturing;

  /// Image has been captured and is displayed for user confirmation
  const factory DocumentScannerState.preview(XFile imageFile) = _Preview;

  /// Processing/enhancing the captured image (ML Kit, perspective correction, etc.)
  const factory DocumentScannerState.processing() = _Processing;

  /// An error occurred during any operation
  const factory DocumentScannerState.error(String message) = _Error;
}
