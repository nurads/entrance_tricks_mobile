import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/chapter_detail_controller.dart';

class NotesTab extends StatelessWidget {
  NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChapterDetailController>(
      builder: (controller) {
        final notes = controller.chapterData['notes'] ?? [];

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getFileColor(note['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getFileIcon(note['type']),
                    color: _getFileColor(note['type']),
                    size: 30,
                  ),
                ),
                title: Text(
                  note['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${note['type']} • ${note['size']}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (note['isDownloaded'])
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Downloaded',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        note['isDownloaded']
                            ? Icons.check_circle
                            : Icons.download,
                      ),
                      color: note['isDownloaded']
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary,
                      onPressed: note['isDownloaded']
                          ? null
                          : () => _downloadNote(note['id']),
                      tooltip: note['isDownloaded'] ? 'Downloaded' : 'Download',
                    ),
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () => _openNote(note['id'], note['type']),
                      tooltip: 'View',
                    ),
                  ],
                ),
                onTap: () => _openNote(note['id'], note['type']),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'markdown':
        return Icons.description;
      default:
        return Icons.description;
    }
  }

  Color _getFileColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'markdown':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _downloadNote(int noteId) {
    Get.snackbar('Info', 'Note download will be implemented');
  }

  void _openNote(int noteId, String type) {
    if (type.toLowerCase() == 'markdown') {
      Get.snackbar('Info', 'Markdown note reader will be implemented');
    } else {
      Get.snackbar('Info', 'PDF note reader will be implemented');
    }
  }
}
