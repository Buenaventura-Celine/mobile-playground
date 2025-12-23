import 'dart:io';
import 'package:image/image.dart' as img;

/// Service for enhancing document images for better readability
/// Applies contrast, brightness, and filtering
class ImageEnhancementService {
  /// Enhance image for better readability and OCR
  /// Adjusts contrast and applies filters
  Future<String> enhanceImage(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      var image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('Could not decode image');

      // Apply enhancements sequentially
      // Enhance contrast to make text more visible (preserves colors)
      image = img.contrast(image, contrast: 1.3);

      // Save enhanced image
      final enhancedPath = _getSavePathForEnhanced(imagePath);
      await File(enhancedPath).writeAsBytes(img.encodePng(image));

      return enhancedPath;
    } catch (e) {
      throw Exception('Failed to enhance image: $e');
    }
  }

  String _getSavePathForEnhanced(String originalPath) {
    final file = File(originalPath);
    final fileName = file.path.split('/').last;
    final nameWithoutExt = fileName.split('.').first;
    final ext = fileName.split('.').last;

    return originalPath.replaceFirst(
      fileName,
      '${nameWithoutExt}_enhanced.$ext',
    );
  }
}
