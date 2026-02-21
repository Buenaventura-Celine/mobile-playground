import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_playground/file_upload/utils/getMockFiles.dart';

class FilesNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() {
    return getMockFiles();
  }

  void addFile(Map<String, dynamic> file) {
    state = [...state, file];
  }

  void removeFile(String fileId) {
    state = state.where((file) => file['id'] != fileId).toList();
  }

  void updateFile(String fileId, Map<String, dynamic> updatedFile) {
    state = state.map((file) {
      if (file['id'] == fileId) {
        return updatedFile;
      }
      return file;
    }).toList();
  }
}

final filesProvider = NotifierProvider<FilesNotifier, List<Map<String, dynamic>>>(
  FilesNotifier.new,
);
