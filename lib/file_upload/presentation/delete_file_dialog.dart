import 'package:flutter/material.dart';

class DeleteFileDialog extends StatelessWidget {
  const DeleteFileDialog({super.key, required this.file});
  final Map<String, dynamic> file;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete File?'),
      content: Text(
        'Are you sure you want to delete "${file['name']}"?\nThis action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${file['name']} deleted'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: Text('Delete', style: TextStyle(color: Colors.red.shade400)),
        ),
      ],
    );
  }
}
