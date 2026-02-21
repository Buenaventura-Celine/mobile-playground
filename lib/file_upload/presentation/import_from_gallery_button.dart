import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_playground/file_upload/application/files_providers.dart';

class ImportFromGalleryButton extends ConsumerWidget {
  const ImportFromGalleryButton({super.key});

  Future<void> _pickImageFromGallery(BuildContext context, WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();

    try {
      developer.log('Gallery picker started');

      // Request permission first
      PermissionStatus status;
      if (Platform.isAndroid) {
        // For Android 13+, request READ_MEDIA_IMAGES
        // For older versions, request READ_EXTERNAL_STORAGE
        status = await Permission.photos.request();
      } else {
        status = await Permission.photos.request();
      }

      if (!status.isGranted) {
        developer.log('Permission denied');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please enable gallery permission in settings'),
              action: SnackBarAction(label: 'Settings', onPressed: openAppSettings),
            ),
          );
        }
        return;
      }

      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final file = File(image.path);
        final fileName = image.name;
        final fileSize = _formatFileSize(file.lengthSync());
        final newFile = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': fileName,
          'size': fileSize,
          'date': 'Today',
          'path': image.path,
        };

        ref.read(filesProvider.notifier).addFile(newFile);

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Added $fileName to files')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _pickImageFromGallery(context, ref),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image, color: colorScheme.primary, size: 28),
                const SizedBox(height: 8),
                Text(
                  'Gallery',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
