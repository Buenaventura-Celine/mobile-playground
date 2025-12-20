import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/document_repository.dart';
import '../document_screen_template.dart';

/// Screen for confirming or retaking a captured image
class PreviewScreen extends ConsumerStatefulWidget {
  final XFile imageFile;

  const PreviewScreen({
    required this.imageFile,
    super.key,
  });

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  bool _isSaving = false;
  int _imageSize = 0;

  @override
  void initState() {
    super.initState();
    _loadImageInfo();
  }

  Future<void> _loadImageInfo() async {
    try {
      final file = File(widget.imageFile.path);
      final stat = await file.stat();

      if (mounted) {
        setState(() {
          _imageSize = stat.size;
        });
      }
    } catch (e) {
      // Ignore errors loading image info
    }
  }

  Future<void> _handleConfirm() async {
    setState(() => _isSaving = true);

    try {
      // Save image using repository
      final repository = ref.read(documentRepositoryProvider);
      await repository.captureAndSaveImage(widget.imageFile);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back to camera
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _handleRetake() async {
    // Navigate back to camera for retaking
    if (mounted) {
      Navigator.pop(context);
    }
  }

  String _formatFileSize(int bytes) {
    const int kb = 1024;
    const int mb = kb * 1024;

    if (bytes < kb) {
      return '$bytes B';
    } else if (bytes < mb) {
      return '${(bytes / kb).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / mb).toStringAsFixed(2)} MB';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Image preview
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(widget.imageFile.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Info card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    DocumentInfoCard(
                      label: 'File Size',
                      value: _formatFileSize(_imageSize),
                      icon: Icons.storage,
                    ),
                    const SizedBox(height: 16),
                    DocumentInfoCard(
                      label: 'Date Captured',
                      value: DateTime.now().toString().split('.')[0],
                      icon: Icons.calendar_today,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Confirm button
                    DocumentActionButton(
                      label: _isSaving ? 'Saving...' : 'Confirm & Save',
                      onPressed: _isSaving ? () {} : _handleConfirm,
                      backgroundColor: DocumentScreenColors.success,
                      textColor: Colors.white,
                      isLoading: _isSaving,
                      icon: Icons.check,
                    ),

                    const SizedBox(height: 12),

                    // Retake button
                    DocumentSecondaryButton(
                      label: 'Retake',
                      onPressed: _isSaving ? () {} : _handleRetake,
                      borderColor: Colors.grey,
                      textColor: Colors.white,
                      icon: Icons.refresh,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
