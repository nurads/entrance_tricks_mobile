import 'package:entrance_tricks/services/api/api.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';

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
    final response = await apiClient.get(
      '/app/videos/$videoId/download?device=$deviceId',
      authenticated: true,
    );
    if (response.statusCode != 200) {
      throw ApiException(response.data['message']);
    }

    final url = response.data['file'];

    FileDownloader.downloadFile(
      url: url,
      downloadDestination: DownloadDestinations.appFiles,
      onProgress: onData,
      onDownloadCompleted: onDone,
      onDownloadError: onError,
    );
  }
}
