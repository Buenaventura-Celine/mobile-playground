import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// Service for correcting perspective distortion in document images
/// Note: This is a simplified version that performs basic straightening
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

      // For now, we'll perform a simple crop-based straightening
      // A full perspective transform would require matrix operations
      final corrected = _performSimpleCorrection(image, corners);

      // Save corrected image
      final correctedPath = _getSavePathForCorrected(imagePath);
      final correctedBytes = img.encodePng(corrected);
      await File(correctedPath).writeAsBytes(correctedBytes);

      return correctedPath;
    } catch (e) {
      throw Exception('Failed to correct perspective: $e');
    }
  }

  /// Perform simple perspective correction by cropping to detected corners
  img.Image _performSimpleCorrection(
    img.Image image,
    List<Offset> corners,
  ) {
    try {
      // Get bounding box from corners
      double minX = corners[0].dx;
      double maxX = corners[0].dx;
      double minY = corners[0].dy;
      double maxY = corners[0].dy;

      for (final corner in corners) {
        minX = minX > corner.dx ? corner.dx : minX;
        maxX = maxX < corner.dx ? corner.dx : maxX;
        minY = minY > corner.dy ? corner.dy : minY;
        maxY = maxY < corner.dy ? corner.dy : maxY;
      }

      // Crop to bounding box
      final x = minX.toInt().clamp(0, image.width - 1);
      final y = minY.toInt().clamp(0, image.height - 1);
      final w = (maxX - minX).toInt().clamp(1, image.width - x);
      final h = (maxY - minY).toInt().clamp(1, image.height - y);

      // Use copyCrop to get the document area
      final cropped = img.copyCrop(
        image,
        x: x,
        y: y,
        width: w,
        height: h,
      );

      // Return the cropped image
      return cropped;
    } catch (e) {
      // If correction fails, return original image
      return image;
    }
  }

  String _getSavePathForCorrected(String originalPath) {
    final file = File(originalPath);
    final fileName = file.path.split('/').last;
    final nameWithoutExt = fileName.split('.').first;
    final ext = fileName.split('.').last;

    return originalPath.replaceFirst(
      fileName,
      '${nameWithoutExt}_corrected.$ext',
    );
  }
}
