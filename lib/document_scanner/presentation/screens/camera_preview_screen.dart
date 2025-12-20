import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/document_scanner_controller.dart';

/// Screen displaying live camera feed with capture and control buttons
class CameraPreviewScreen extends ConsumerStatefulWidget {
  final CameraDescription selectedCamera;
  final FlashMode flashMode;
  final double zoomLevel;

  const CameraPreviewScreen({
    required this.selectedCamera,
    required this.flashMode,
    required this.zoomLevel,
    super.key,
  });

  @override
  ConsumerState<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends ConsumerState<CameraPreviewScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  double _currentZoom = 1.0;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameraController = CameraController(
        widget.selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController.initialize();
      _currentZoom = 1.0;

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize camera: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _handleCapture() async {
    if (!_isCameraInitialized || _cameraController.value.isTakingPicture) {
      return;
    }

    try {
      await ref.read(documentScannerControllerProvider.notifier).captureImage();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture image: $e')),
        );
      }
    }
  }

  Future<void> _handleFlashToggle() async {
    final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
    try {
      await ref.read(documentScannerControllerProvider.notifier).setFlashMode(newFlashMode);
      if (mounted) {
        setState(() {
          _isFlashOn = !_isFlashOn;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to set flash: $e')),
        );
      }
    }
  }

  Future<void> _handleZoomChange(double zoom) async {
    try {
      await ref.read(documentScannerControllerProvider.notifier).setZoom(zoom);
      if (mounted) {
        setState(() {
          _currentZoom = zoom;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to set zoom: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera preview
          SizedBox.expand(
            child: CameraPreview(_cameraController),
          ),

          // Overlay controls
          SafeArea(
            child: Column(
              children: [
                // Top bar with flash and settings
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Flash button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isFlashOn ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                          ),
                          onPressed: _handleFlashToggle,
                        ),
                      ),

                      // Zoom indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentZoom.toStringAsFixed(1)}x',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Gallery button (optional - for Phase 5.3)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // TODO: Navigate to gallery in Phase 5.3
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom controls
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Zoom slider
                      Row(
                        children: [
                          const Icon(
                            Icons.zoom_out,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Slider(
                              value: _currentZoom,
                              min: 1.0,
                              max: 5.0,
                              onChanged: _handleZoomChange,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.zoom_in,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Capture button
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            iconSize: 48,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: _handleCapture,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
