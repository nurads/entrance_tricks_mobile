import 'package:entrance_tricks/services/api/api.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'dart:io';

class VideoApiService {
  final ApiClient apiClient = ApiClient();

  Future<List<Video>> getVideos(
    int chapterId, {
    required String deviceId,
  }) async {
    final response = await apiClient.get(
      '/app/videos?device=$deviceId&chapter=$chapterId',
      authenticated: true,
    );
    logger.d(response.data);
    return (response.data as List).map((e) => Video.fromJson(e)).toList();
  }

  Future<Video> getVideo(int videoId, {required String deviceId}) async {
    final response = await apiClient.get(
      '/app/videos/$videoId?device=$deviceId',
      authenticated: true,
    );

    if (response.statusCode == 200) {
      return Video.fromJson(response.data);
    }

    throw ApiException(response.data['message']);
  }

  Future<void> downloadVideo(
    int videoId, {
    required String deviceId,
    required Function(String?, double) onData,
    required Function(String) onDone,
    required Function(String) onError,
  }) async {
    try {
      final response = await apiClient.get(
        '/app/videos/$videoId?device=$deviceId',
        authenticated: true,
      );
      if (response.statusCode != 200) {
        throw ApiException(response.data['message']);
      }

      final url = response.data['file'];

      // Get app documents directory for storing videos
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String videosDir = '${appDocDir.path}/videos';

      // Create videos directory if it doesn't exist
      final Directory videosDirObj = Directory(videosDir);
      if (!await videosDirObj.exists()) {
        await videosDirObj.create(recursive: true);
      }

      // Generate filename from URL or use video ID
      String fileName = 'video_$videoId.mp4';
      final String fullPath = '$videosDir/$fileName';

      logger.d('Downloading video to: $fullPath');

      FileDownloader.downloadFile(
        url: url,
        name: fileName,
        subPath: 'videos',
        downloadDestination: DownloadDestinations.appFiles,
        onProgress: onData,
        onDownloadCompleted: (String path) {
          logger.d('Video downloaded to: $path');
          // Ensure we return the full absolute path
          onDone(path);
        },
        onDownloadError: (String error) {
          logger.e('Download error: $error');
          onError(error);
        },
      );
    } catch (e) {
      logger.e('Error in downloadVideo: $e');
      onError(e.toString());
    }
  }
}
