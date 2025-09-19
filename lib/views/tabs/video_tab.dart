import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/subject/chapter_detail_controller.dart';
import 'package:entrance_tricks/models/models.dart';

class VideoTab extends StatelessWidget {
  VideoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<ChapterDetailController>(
      builder: (controller) {
        if (controller.videos.isEmpty) {
          return _buildEmptyState(context);
        }

        return Container(
          color: theme.colorScheme.background,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final video = controller.videos[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildModernVideoCard(context, video, controller),
                    );
                  }, childCount: controller.videos.length),
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
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.secondary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.video_library_outlined,
              size: 60,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Videos Available',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Videos for this chapter will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernVideoCard(
    BuildContext context,
    Video video,
    ChapterDetailController controller,
  ) {
    final theme = Theme.of(context);
    final bool isLocked = video.isLocked;
    final bool isWatched = video.isWatched;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked ? null : () => controller.playVideo(video.id),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Video Thumbnail
                Container(
                  width: 100,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isLocked
                          ? [Colors.grey[300]!, Colors.grey[400]!]
                          : [
                              theme.colorScheme.primary.withOpacity(0.8),
                              theme.colorScheme.secondary.withOpacity(0.6),
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isLocked
                                    ? Colors.grey[400]!
                                    : theme.colorScheme.primary)
                                .withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Play icon
                      Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isLocked ? Icons.lock : Icons.play_arrow,
                            color: isLocked
                                ? Colors.grey[600]
                                : theme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ),

                      // Duration badge
                      if (video.duration != 0)
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              video.duration.toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      // Watched indicator
                      if (isWatched && !isLocked)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.secondary
                                      .withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(width: 20),

                // Video Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isLocked
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),

                      Row(
                        children: [
                          if (isWatched && !isLocked) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.secondary
                                      .withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Watched',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                          ],
                          if (isLocked) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.error.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock,
                                    size: 16,
                                    color: theme.colorScheme.error,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Locked',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.error,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Action button
                if (!isLocked)
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => _downloadVideo(video.id),
                      icon: Icon(
                        Icons.download_outlined,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _downloadVideo(int videoId) {
    Get.snackbar('Info', 'Video download will be implemented');
  }
}
