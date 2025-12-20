import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

/// Service for handling all file system operations for the document scanner.
/// Lives in the Data Layer (Datasources).
///
/// Responsibilities:
/// - Save images to temporary directory
/// - Move images to permanent application documents directory
/// - Delete images from storage
/// - Read images from storage
/// - List saved documents
/// - Manage file lifecycle and metadata
///
/// This datasource encapsulates all file I/O details and provides
/// a clean interface for the repository to use.
class FileDataSource {
  /// Save an image to the temporary directory
  /// Returns the path to the temporary file
  Future<String> saveImageToTemp(XFile image) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempPath = '${tempDir.path}/temp_document_$timestamp.jpg';

      // Copy the image file to temp directory
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(await image.readAsBytes());

      return tempPath;
    } catch (e) {
      throw Exception('Failed to save image to temp: $e');
    }
  }

  /// Move image from temp directory to application documents directory
  /// Returns the path to the final file
  Future<String> moveToApplicationDocuments(String tempPath) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'document_$timestamp.jpg';
      final finalPath = '${appDocDir.path}/documents/$fileName';

      // Ensure documents directory exists
      final documentsDir = Directory('${appDocDir.path}/documents');
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      // Move file from temp to documents
      final tempFile = File(tempPath);
      final finalFile = await tempFile.rename(finalPath);

      return finalFile.path;
    } catch (e) {
      throw Exception('Failed to move image to documents: $e');
    }
  }

  /// Delete an image file from application documents
  Future<void> deleteImage(String filePath) async {
    try {
      final file = File(filePath);

      // Only delete if file exists
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Get list of all saved document files
  /// Returns a list of file paths, sorted by creation time (newest first)
  Future<List<String>> getDocumentList() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final documentsDir = Directory('${appDocDir.path}/documents');

      // Return empty list if directory doesn't exist
      if (!await documentsDir.exists()) {
        return [];
      }

      // Get all jpg files from documents directory
      final files = documentsDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.jpg'))
          .toList();

      // Sort by modification time (newest first)
      files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      // Return list of file paths
      return files.map((file) => file.path).toList();
    } catch (e) {
      throw Exception('Failed to get document list: $e');
    }
  }

  /// Read image file bytes from the given path
  Future<List<int>> readImageFile(String filePath) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      return await file.readAsBytes();
    } catch (e) {
      throw Exception('Failed to read image file: $e');
    }
  }

  /// Get File object from the given path
  Future<File> getFile(String filePath) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      return file;
    } catch (e) {
      throw Exception('Failed to get file: $e');
    }
  }

  /// Get metadata for a document file
  Future<DocumentFileMetadata> getFileMetadata(String filePath) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final stat = file.statSync();

      return DocumentFileMetadata(
        filePath: filePath,
        fileName: file.path.split('/').last,
        fileSize: stat.size,
        createdAt: stat.modified,
        lastModified: stat.modified,
      );
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  /// Get the application documents directory path
  Future<String> getApplicationDocumentsPath() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      return appDocDir.path;
    } catch (e) {
      throw Exception('Failed to get documents directory: $e');
    }
  }

  /// Delete all temporary files (cleanup)
  Future<void> cleanupTemporaryFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.contains('temp_document_'))
          .toList();

      for (final file in files) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to cleanup temporary files: $e');
    }
  }
}

/// Metadata for a document file
class DocumentFileMetadata {
  final String filePath;
  final String fileName;
  final int fileSize;
  final DateTime createdAt;
  final DateTime lastModified;

  DocumentFileMetadata({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.createdAt,
    required this.lastModified,
  });

  /// Get human-readable file size
  String get formattedFileSize {
    const int kb = 1024;
    const int mb = kb * 1024;

    if (fileSize < kb) {
      return '$fileSize B';
    } else if (fileSize < mb) {
      return '${(fileSize / kb).toStringAsFixed(2)} KB';
    } else {
      return '${(fileSize / mb).toStringAsFixed(2)} MB';
    }
  }
}
