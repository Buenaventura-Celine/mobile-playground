import 'package:flutter/material.dart';
import 'package:mobile_playground/file_upload/presentation/delete_file_dialog.dart';
import 'package:mobile_playground/file_upload/presentation/file_preview_bottomsheet.dart';

class FileGridItem extends StatelessWidget {
  const FileGridItem({super.key, required this.file});
  final Map<String, dynamic> file;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => FilePreviewBottomSheet(file: file),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Stack(
          children: [
            // Thumbnail
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  color: colorScheme.primary.withValues(alpha: 0.5),
                  size: 40,
                ),
              ),
            ),
            // Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.4)],
                ),
              ),
            ),
            // File name at bottom
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                file['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Delete button
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => DeleteFileDialog(file: file),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
