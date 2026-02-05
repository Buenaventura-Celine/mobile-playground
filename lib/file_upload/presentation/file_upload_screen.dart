import 'package:flutter/material.dart';
import 'package:mobile_playground/file_upload/presentation/empty_file_list.dart';
import 'package:mobile_playground/file_upload/presentation/file_grid.dart/file_grid.dart';
import 'package:mobile_playground/file_upload/presentation/file_list/file_list.dart';
import 'package:mobile_playground/file_upload/presentation/import_from_file_manager_button.dart';
import 'package:mobile_playground/file_upload/presentation/import_from_gallery_button.dart';
import 'package:mobile_playground/file_upload/presentation/take_photo_button.dart';
import 'package:mobile_playground/file_upload/utils/getMockFiles.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final files = getMockFiles();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'File Upload',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          // Toggle view button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Tooltip(
              message: _isGridView ? 'Switch to list view' : 'Switch to grid view',
              child: IconButton(
                onPressed: () => setState(() => _isGridView = !_isGridView),
                icon: Icon(
                  _isGridView ? Icons.view_list : Icons.grid_view,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Files',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Pick from gallery
                    ImportFromGalleryButton(),
                    const SizedBox(width: 12),
                    TakePhotoButton(),
                    const SizedBox(width: 12),
                    ImportFromFileManagerButton(),
                  ],
                ),
              ],
            ),
          ),

          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            height: 24,
            indent: 16,
            endIndent: 16,
          ),

          files.isEmpty
              ? EmptyFileList()
              : _isGridView
              ? FileGrid()
              : FileList(),
        ],
      ),
    );
  }
}
