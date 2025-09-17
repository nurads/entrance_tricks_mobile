import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/chapter_detail_controller.dart';

class NotesTab extends StatelessWidget {
  NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<ChapterDetailController>(
      builder: (controller) {
        if (controller.notes.isEmpty) {
          return _buildEmptyState(context);
        }

        return Container(
          color: theme.scaffoldBackgroundColor,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final note = controller.notes[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildModernNoteCard(context, note, controller),
                    );
                  }, childCount: controller.notes.length),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  theme.colorScheme.secondary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.description_outlined,
              size: 60,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Notes Available',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Notes and materials for this chapter will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernNoteCard(
    BuildContext context,
    Map<String, dynamic> note,
    ChapterDetailController controller,
  ) {
    final theme = Theme.of(context);
    final String type = note['type'] ?? 'PDF';
    final bool isDownloaded = note['isDownloaded'] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNoteTap(note, controller),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(16), // Reduced from 20
            child: Row(
              children: [
                // File Type Icon
                Container(
                  width: 56, // Reduced from 64
                  height: 56, // Reduced from 64
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _getFileTypeColor(type),
                        _getFileTypeColor(type).withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16), // Reduced from 18
                    boxShadow: [
                      BoxShadow(
                        color: _getFileTypeColor(type).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getFileTypeIcon(type),
                    color: Colors.white,
                    size: 26, // Reduced from 30
                  ),
                ),

                SizedBox(width: 16), // Reduced from 20
                // Note Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note['name'] ?? 'Note Title',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10), // Reduced from 12
                      // Use Wrap instead of Row to prevent overflow
                      Wrap(
                        spacing: 8, // Reduced from 12
                        runSpacing: 6,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8, // Reduced from 10
                              vertical: 4, // Reduced from 6
                            ),
                            decoration: BoxDecoration(
                              color: _getFileTypeColor(
                                type,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Reduced from 16
                              border: Border.all(
                                color: _getFileTypeColor(
                                  type,
                                ).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              type.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                // Changed to labelSmall
                                color: _getFileTypeColor(type),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8, // Reduced from 10
                              vertical: 4, // Reduced from 6
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Reduced from 16
                            ),
                            child: Text(
                              note['size'] ?? '0 MB',
                              style: theme.textTheme.labelSmall?.copyWith(
                                // Changed to labelSmall
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isDownloaded)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8, // Reduced from 10
                                vertical: 4, // Reduced from 6
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Reduced from 16
                                border: Border.all(
                                  color: theme.colorScheme.secondary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 14, // Reduced from 16
                                    color: theme.colorScheme.secondary,
                                  ),
                                  SizedBox(width: 4), // Reduced from 6
                                  Text(
                                    'Downloaded',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      // Changed to labelSmall
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action button
                Container(
                  decoration: BoxDecoration(
                    color: isDownloaded
                        ? theme.colorScheme.secondary.withValues(alpha: 0.1)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14), // Reduced from 16
                    border: Border.all(
                      color: isDownloaded
                          ? theme.colorScheme.secondary.withValues(alpha: 0.2)
                          : theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () => _handleNoteAction(note, controller),
                    icon: Icon(
                      _getActionIcon(note),
                      color: isDownloaded
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.primary,
                      size: 18, // Reduced from 20
                    ),
                    padding: EdgeInsets.all(8), // Reduced padding
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNoteTap(
    Map<String, dynamic> note,
    ChapterDetailController controller,
  ) {
    final String type = note['type']?.toLowerCase() ?? 'pdf';

    if (type == 'pdf') {
      controller.openPDF(note['id']);
    } else {
      // For other types, show a message or implement other viewers
      Get.snackbar('Info', 'Opening ${type.toUpperCase()} viewer');
    }
  }

  void _handleNoteAction(
    Map<String, dynamic> note,
    ChapterDetailController controller,
  ) {
    final String type = note['type']?.toLowerCase() ?? 'pdf';
    final bool isDownloaded = note['isDownloaded'] ?? false;

    if (type == 'pdf') {
      if (isDownloaded) {
        controller.openPDF(note['id']);
      } else {
        controller.downloadNote(note['id']);
      }
    } else {
      controller.downloadNote(note['id']);
    }
  }

  IconData _getActionIcon(Map<String, dynamic> note) {
    final String type = note['type']?.toLowerCase() ?? 'pdf';
    final bool isDownloaded = note['isDownloaded'] ?? false;

    if (type == 'pdf' && isDownloaded) {
      return Icons.folder_open;
    } else {
      return Icons.download_outlined;
    }
  }

  Color _getFileTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Color(0xFFE53E3E); // Red-500
      case 'doc':
      case 'docx':
        return Color(0xFF3182CE); // Blue-500
      case 'ppt':
      case 'pptx':
        return Color(0xFFDD6B20); // Orange-500
      case 'markdown':
      case 'md':
        return Color(0xFF805AD5); // Purple-500
      default:
        return Color(0xFF718096); // Gray-500
    }
  }

  IconData _getFileTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'markdown':
      case 'md':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }
}
