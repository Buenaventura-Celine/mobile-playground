import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/file_datasource.dart';

/// Riverpod provider for the document repository
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final fileDataSource = FileDataSource();
  return DocumentRepository(fileDataSource: fileDataSource);
});

/// Repository for managing document file operations.
/// Lives in the Data Layer (Repositories).
///
/// Responsibilities:
/// - Coordinate file I/O operations
/// - Handle image lifecycle (capture → temp → documents)
/// - Provide document management API (list, delete, read)
/// - Abstract away file system complexity
///
/// This repository provides a clean interface for the controller/services
/// to use without worrying about file paths and directories.
class DocumentRepository {
  final FileDataSource _fileDataSource;

  DocumentRepository({
    required FileDataSource fileDataSource,
  }) : _fileDataSource = fileDataSource;

  /// Save a captured image to temporary storage
  /// Returns the path to the temporary file
  Future<String> saveImageToTemp(XFile image) async {
    try {
      return await _fileDataSource.saveImageToTemp(image);
    } catch (e) {
      throw Exception('Failed to save image to temp: $e');
    }
  }

  /// Move image from temporary storage to permanent application documents
  /// Returns the path to the final file
  Future<String> moveToApplicationDocuments(String tempPath) async {
    try {
      return await _fileDataSource.moveToApplicationDocuments(tempPath);
    } catch (e) {
      throw Exception('Failed to move image to documents: $e');
    }
  }

  /// Complete workflow: save captured image and move to documents
  /// Returns the final file path
  Future<String> captureAndSaveImage(XFile image) async {
    try {
      // 1. Save to temp
      final tempPath = await _fileDataSource.saveImageToTemp(image);

      // 2. Move to documents
      final finalPath = await _fileDataSource.moveToApplicationDocuments(tempPath);

      return finalPath;
    } catch (e) {
      throw Exception('Failed to capture and save image: $e');
    }
  }

  /// Delete a document from application documents
  Future<void> deleteDocument(String filePath) async {
    try {
      await _fileDataSource.deleteImage(filePath);
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  /// Get list of all saved documents
  /// Returns a list of file paths, sorted by newest first
  Future<List<String>> getDocumentList() async {
    try {
      return await _fileDataSource.getDocumentList();
    } catch (e) {
      throw Exception('Failed to get document list: $e');
    }
  }

  /// Read image file bytes from the given path
  Future<List<int>> readImageFile(String filePath) async {
    try {
      return await _fileDataSource.readImageFile(filePath);
    } catch (e) {
      throw Exception('Failed to read image file: $e');
    }
  }

  /// Get File object from the given path
  Future<File> getFile(String filePath) async {
    try {
      return await _fileDataSource.getFile(filePath);
    } catch (e) {
      throw Exception('Failed to get file: $e');
    }
  }

  /// Get metadata for a document file
  Future<DocumentFileMetadata> getFileMetadata(String filePath) async {
    try {
      return await _fileDataSource.getFileMetadata(filePath);
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  /// Get metadata for all saved documents
  /// Returns a list of metadata objects sorted by newest first
  Future<List<DocumentFileMetadata>> getAllDocumentsMetadata() async {
    try {
      final filePaths = await _fileDataSource.getDocumentList();
      final metadataList = <DocumentFileMetadata>[];

      for (final filePath in filePaths) {
        try {
          final metadata = await _fileDataSource.getFileMetadata(filePath);
          metadataList.add(metadata);
        } catch (e) {
          // Skip files that can't be read
          continue;
        }
      }

      return metadataList;
    } catch (e) {
      throw Exception('Failed to get documents metadata: $e');
    }
  }

  /// Get the application documents directory path
  Future<String> getApplicationDocumentsPath() async {
    try {
      return await _fileDataSource.getApplicationDocumentsPath();
    } catch (e) {
      throw Exception('Failed to get documents directory: $e');
    }
  }

  /// Delete all temporary files (cleanup)
  Future<void> cleanupTemporaryFiles() async {
    try {
      await _fileDataSource.cleanupTemporaryFiles();
    } catch (e) {
      throw Exception('Failed to cleanup temporary files: $e');
    }
  }

  /// Delete all documents (full cleanup)
  Future<void> deleteAllDocuments() async {
    try {
      final filePaths = await _fileDataSource.getDocumentList();
      for (final filePath in filePaths) {
        await _fileDataSource.deleteImage(filePath);
      }
    } catch (e) {
      throw Exception('Failed to delete all documents: $e');
    }
  }
}
