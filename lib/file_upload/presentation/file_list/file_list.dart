import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_playground/file_upload/application/files_providers.dart';
import 'package:mobile_playground/file_upload/presentation/file_list/file_list_item.dart';

class FileList extends ConsumerWidget {
  const FileList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(filesProvider);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: files.length,
      itemBuilder: (context, index) {
        return FileListItem(file: files[index]);
      },
    );
    
  }
}