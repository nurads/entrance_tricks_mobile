import 'package:entrance_tricks/services/api/api.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class NoteService {
  final ApiClient apiClient = ApiClient();

  Future<List<Note>> getNotes(String deviceId, {required int chapterId}) async {
    final response = await apiClient.get(
      '/app/notes?chapter=$chapterId&device=$deviceId',
      authenticated: true,
    );
    return (response.data as List).map((e) => Note.fromJson(e)).toList();
  }

  Future<void> downloadNote(
    int noteId, {
    required String deviceId,
    required Function(String?, double) onData,
    required Function(String) onDone,
    required Function(String) onError,
  }) async {
    final response = await apiClient.get(
      '/app/notes/$noteId?device=$deviceId',
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
