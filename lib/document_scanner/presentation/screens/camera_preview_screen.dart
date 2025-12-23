import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/document_scanner_controller.dart';

/// Screen displaying live camera feed with capture and control buttons
class CameraPreviewScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(documentScannerControllerProvider.notifier);
    final cameraController = controller.cameraController;
    final isInitialized = controller.isCameraInitialized;

    if (!isInitialized || cameraController == null) {
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

    return _CameraPreviewContent(
      cameraController: cameraController,
      controller: controller,
    );
  }
}

class _CameraPreviewContent extends StatefulWidget {
  final CameraController cameraController;
  final DocumentScannerController controller;

  const _CameraPreviewContent({
    required this.cameraController,
    required this.controller,
  });

  @override
  State<_CameraPreviewContent> createState() => _CameraPreviewContentState();
}

class _CameraPreviewContentState extends State<_CameraPreviewContent> {
  double _currentZoom = 1.0;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _currentZoom = 1.0;
  }

  Future<void> _handleCapture() async {
    if (widget.cameraController.value.isTakingPicture) {
      return;
    }

    try {
      await widget.controller.captureImage();
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
      await widget.controller.setFlashMode(newFlashMode);
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
      await widget.controller.setZoom(zoom);
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
    return Scaffold(
      body: Stack(
        children: [
          // Camera preview - use the controller's camera
          SizedBox.expand(
            child: CameraPreview(widget.cameraController),
          ),

          // Document frame guide overlay
          const _DocumentFrameGuide(),

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

/// Document frame guide overlay for proper positioning
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

/// Painter that draws the document frame guide
class DocumentFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw corner markers
    final framePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Define document frame area (80% of screen centered)
    final frameRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.15,
      size.width * 0.8,
      size.height * 0.7,
    );

    // Draw frame outline
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(8)),
      framePaint,
    );

    // Draw corner guides
    final corners = [
      frameRect.topLeft,
      frameRect.topRight,
      frameRect.bottomRight,
      frameRect.bottomLeft,
    ];

    for (final corner in corners) {
      // Draw corner circles
      canvas.drawCircle(corner, 6, framePaint);
    }

    // Draw helper text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Position document within frame',
        style: TextStyle(
          color: Colors.green,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        frameRect.bottom + 20,
      ),
    );
  }

  @override
  bool shouldRepaint(DocumentFramePainter oldDelegate) => false;
}
