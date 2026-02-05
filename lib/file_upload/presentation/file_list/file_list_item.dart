import 'package:flutter/material.dart';
import 'package:mobile_playground/file_upload/presentation/delete_file_dialog.dart';
import 'package:mobile_playground/file_upload/presentation/file_preview_bottomsheet.dart';

class FileListItem extends StatelessWidget {
  const FileListItem({super.key, required this.file});
   final Map<String, dynamic> file;

  @override
  Widget build(BuildContext context) {
     final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => FilePreviewBottomSheet(file: file),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => FilePreviewBottomSheet(file: file),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Thumbnail
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
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
                  const SizedBox(width: 16),
                  // File info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file['name'],
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              file['size'],
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              file['date'],
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete button
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red.withValues(alpha: 0.7),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => DeleteFileDialog(file: file),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
  }
}