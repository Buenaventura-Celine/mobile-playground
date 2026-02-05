import 'package:flutter/material.dart';
import 'package:mobile_playground/file_upload/presentation/file_list/file_list_item.dart';
import 'package:mobile_playground/file_upload/utils/getMockFiles.dart';

class FileList extends StatelessWidget {
  const FileList({super.key});

  @override
  Widget build(BuildContext context) {
     final files = getMockFiles();
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