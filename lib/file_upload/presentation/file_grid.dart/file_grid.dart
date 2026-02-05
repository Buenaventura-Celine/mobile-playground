import 'package:flutter/material.dart';
import 'package:mobile_playground/file_upload/presentation/file_grid.dart/file_grid_item.dart';
import 'package:mobile_playground/file_upload/utils/getMockFiles.dart';

class FileGrid extends StatelessWidget {
  const FileGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final files = getMockFiles();
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        return FileGridItem(file: files[index]);
      },
    );
  }
}
