import 'package:flutter/material.dart';

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
          // Upload action buttons
          _buildUploadActionSection(context),

          // Divider
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            height: 24,
            indent: 16,
            endIndent: 16,
          ),

          // Uploaded files list/grid
          Expanded(
            child: _buildFilesList(context),
          ),
        ],
      ),
    );
  }

  /// Build upload action buttons section
  Widget _buildUploadActionSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
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
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.image,
                  label: 'Gallery',
                  onPressed: () => _showGalleryPicker(context),
                ),
              ),
              const SizedBox(width: 12),
              // Take photo
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onPressed: () => _showCameraPicker(context),
                ),
              ),
              const SizedBox(width: 12),
              // File browser
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.folder,
                  label: 'Files',
                  onPressed: () => _showFilePicker(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build individual action button
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
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
              Icon(
                icon,
                color: colorScheme.primary,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build uploaded files list/grid
  Widget _buildFilesList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Mock data - replace with real data from provider
    final files = _getMockFiles();

    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_upload_outlined,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No files uploaded yet',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your first file to get started',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (_isGridView) {
      return _buildGridView(context, files);
    } else {
      return _buildListView(context, files);
    }
  }

  /// Build grid view of files
  Widget _buildGridView(BuildContext context, List<Map<String, dynamic>> files) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        return _buildGridFileItem(context, files[index]);
      },
    );
  }

  /// Build individual grid file item
  Widget _buildGridFileItem(
    BuildContext context,
    Map<String, dynamic> file,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showFilePreview(context, file),
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
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
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
                onTap: () => _confirmDelete(context, file),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build list view of files
  Widget _buildListView(BuildContext context, List<Map<String, dynamic>> files) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: files.length,
      itemBuilder: (context, index) {
        return _buildListFileItem(context, files[index]);
      },
    );
  }

  /// Build individual list file item
  Widget _buildListFileItem(
    BuildContext context,
    Map<String, dynamic> file,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => _showFilePreview(context, file),
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
            onTap: () => _showFilePreview(context, file),
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
                    onPressed: () => _confirmDelete(context, file),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Mock file data
  List<Map<String, dynamic>> _getMockFiles() {
    return [
      {
        'id': '1',
        'name': 'Project Design',
        'size': '2.5 MB',
        'date': 'Today',
      },
      {
        'id': '2',
        'name': 'Wireframe Sketch',
        'size': '1.2 MB',
        'date': 'Yesterday',
      },
      {
        'id': '3',
        'name': 'User Flow',
        'size': '856 KB',
        'date': 'Dec 1',
      },
      {
        'id': '4',
        'name': 'Color Palette',
        'size': '345 KB',
        'date': 'Nov 28',
      },
    ];
  }

  // Action handlers
  void _showGalleryPicker(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery picker would open here')),
    );
  }

  void _showCameraPicker(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera would open here')),
    );
  }

  void _showFilePicker(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File browser would open here')),
    );
  }

  void _showFilePreview(BuildContext context, Map<String, dynamic> file) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview image
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: colorScheme.primary.withValues(alpha: 0.5),
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // File details
                Text(
                  file['name'],
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Size: ${file['size']}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Date: ${file['date']}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _confirmDelete(context, file);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }
}