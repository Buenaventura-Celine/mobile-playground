import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// Service for detecting document boundaries in images
/// Simplified version using edge detection
class DocumentDetectionService {
  /// Detect document corners in an image
  /// Returns list of corner coordinates (top-left, top-right, bottom-right, bottom-left)
  /// Returns null if no document is detected
  Future<List<Offset>?> detectDocumentCorners(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) return null;

      // Find edge points using a simple edge detection approach
      final edgePoints = _detectEdges(image);

      if (edgePoints.isEmpty) return null;

      // Find convex hull corners
      final corners = _findConvexHullCorners(edgePoints);

      // Validate if we found a valid document
      if (corners != null && corners.length == 4) {
        if (_isValidDocument(corners, image.width, image.height)) {
          return corners;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Failed to detect document corners: $e');
    }
  }

  /// Simple edge detection using brightness thresholding
  List<Offset> _detectEdges(img.Image image) {
    final edges = <Offset>[];
    const threshold = 100; // Threshold for edge detection

    for (int y = 0; y < image.height; y += 2) {
      for (int x = 0; x < image.width; x += 2) {
        final pixel = image.getPixel(x, y);

        // Get RGBA values from pixel object
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        // Calculate brightness
        final brightness = (0.299 * r + 0.587 * g + 0.114 * b).toInt();

        // Look for dark areas (potential document edges)
        if (brightness < threshold) {
          edges.add(Offset(x.toDouble(), y.toDouble()));
        }
      }
    }

    return edges;
  }

  /// Find 4 corners of the document using extreme points
  List<Offset>? _findConvexHullCorners(List<Offset> points) {
    if (points.length < 4) return null;

    // Find extreme points
    var topLeft = points[0];
    var topRight = points[0];
    var bottomLeft = points[0];
    var bottomRight = points[0];

    for (final point in points) {
      // Top-left: minimize x+y
      if (point.dx + point.dy < topLeft.dx + topLeft.dy) {
        topLeft = point;
      }

      // Top-right: maximize x-y
      if (point.dx - point.dy > topRight.dx - topRight.dy) {
        topRight = point;
      }

      // Bottom-left: minimize x-y
      if (point.dy - point.dx > bottomLeft.dy - bottomLeft.dx) {
        bottomLeft = point;
      }

      // Bottom-right: maximize x+y
      if (point.dx + point.dy > bottomRight.dx + bottomRight.dy) {
        bottomRight = point;
      }
    }

    return [topLeft, topRight, bottomRight, bottomLeft];
  }

  /// Check if detected corners form a valid document
  bool _isValidDocument(List<Offset> corners, int imgWidth, int imgHeight) {
    if (corners.length != 4) return false;

    // Calculate area using shoelace formula
    final area = _calculatePolygonArea(corners);

    // Document should be at least 5% of image area
    final minArea = (imgWidth * imgHeight * 0.05);

    return area > minArea;
  }

  /// Calculate polygon area using shoelace formula
  double _calculatePolygonArea(List<Offset> points) {
    if (points.length < 3) return 0;

    double area = 0;
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];
      area += p1.dx * p2.dy - p2.dx * p1.dy;
    }

    return (area / 2).abs();
  }
}
