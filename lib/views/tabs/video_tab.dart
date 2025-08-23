import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/chapter_detail_controller.dart';

class VideoTab extends StatelessWidget {
  VideoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChapterDetailController>(
      builder: (controller) {
        final videos = controller.chapterData['videos'] ?? [];

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.play_circle_filled,
                        color: video['isLocked']
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                    ),
                    if (video['isLocked'])
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    if (video['isWatched'])
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  video['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: video['isLocked']
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : null,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 4),
                    Text(
                      video['duration'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                trailing: video['isLocked']
                    ? Icon(
                        Icons.lock,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () => _downloadVideo(video['id']),
                            tooltip: 'Download',
                          ),
                          IconButton(
                            icon: Icon(Icons.play_arrow),
                            onPressed: () => _playVideo(video['id']),
                            tooltip: 'Play',
                          ),
                        ],
                      ),
                onTap: video['isLocked'] ? null : () => _playVideo(video['id']),
              ),
            );
          },
        );
      },
    );
  }

  void _playVideo(int videoId) {
    Get.snackbar('Info', 'Video player will be implemented');
  }

  void _downloadVideo(int videoId) {
    Get.snackbar('Info', 'Video download will be implemented');
  }
}
