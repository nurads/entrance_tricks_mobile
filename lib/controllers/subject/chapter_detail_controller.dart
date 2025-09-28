import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/storages/storages.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/controllers/subject/subject_detail_controller.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/utils/device/device.dart';
import 'package:entrance_tricks/services/services.dart';
import 'dart:io';

class ChapterDetailController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isVideosLoading = false;
  bool get isVideosLoading => _isVideosLoading;

  bool _isNotesLoading = false;
  bool get isNotesLoading => _isNotesLoading;
  bool _isQuizzesLoading = true;
  bool get isQuizzesLoading => _isQuizzesLoading;

  String _chapterTitle = '';
  String get chapterTitle => _chapterTitle;

  Chapter? _chapter;
  Chapter? get chapter => _chapter;

  List<Video> _videos = [];
  List<Video> get videos => _videos;

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  List<Exam> _quizzes = [];
  List<Exam> get quizzes => _quizzes;

  int chapterId = 0;
  int subjectId = 0;

  RxMap<int, dynamic> videoDownloadProgress = RxMap<int, dynamic>({});
  RxMap<int, dynamic> noteDownloadProgress = RxMap<int, dynamic>({});

  final HiveVideoStorage _hiveVideoStorage = HiveVideoStorage();
  final HiveNoteStorage _hiveNoteStorage = HiveNoteStorage();
  final ExamService _examService = ExamService();
  final HiveExamStorage _examStorage = HiveExamStorage();
  final VideoApiService _videoApiService = VideoApiService();
  final NoteService _noteApiService = NoteService();
  User? _user;

  @override
  void onInit() async {
    chapterId = Get.arguments?['chapterId'] ?? 1;
    subjectId = Get.arguments?['subjectId'] ?? 1;
    loadChapterDetail();
    loadVideos();
    loadNotes();
    loadQuizzes();
    _loadDownloadedNotes(); // Add this line
    _user = await HiveUserStorage().getUser();
    HiveUserStorage().listen((event) {
      _user = event;
      loadChapterDetail();
      loadVideos();
      loadNotes();
      loadQuizzes();
    }, 'user');
    super.onInit();
  }

  void loadVideos() async {
    final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');
    _isVideosLoading = true;
    update();
    try {
      final videos_ = await _videoApiService.getVideos(
        chapterId,
        deviceId: device.id,
      );

      _hiveVideoStorage.setVideos(chapterId, videos_);
      _videos = await _hiveVideoStorage.getVideos(chapterId);
    } catch (e) {
      logger.e('Error loading videos: $e');
      _videos = await _hiveVideoStorage.getVideos(chapterId);
    }
    _isVideosLoading = false;
    update();
  }

  void loadNotes() async {
    final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');
    _isNotesLoading = true;
    update();
    try {
      final notes_ = await _noteApiService.getNotes(
        device.id,
        chapterId: chapterId,
      );
      _hiveNoteStorage.setNotes(chapterId, notes_);
      _notes = await _hiveNoteStorage.getNotes(chapterId);
    } catch (e) {
      logger.e('Error loading notes: $e');
      _notes = await _hiveNoteStorage.getNotes(chapterId);
    }
    _isNotesLoading = false;
    update();
  }

  void loadQuizzes() async {
    final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');
    _isQuizzesLoading = true;
    update();
    try {
      final quizzes_ = await _examService.getAvailableExams(
        device.id,
        chapterId: chapterId,
        examType: "quiz",
      );
      _examStorage.setQuizzes(chapterId, quizzes_);
      _quizzes = await _examStorage.getQuizzes(chapterId);
    } catch (e) {
      _quizzes = await _examService.getAvailableExams(
        device.id,
        chapterId: chapterId,
        examType: "quiz",
      );
    }
    _isQuizzesLoading = false;
    update();
  }

  void loadChapterDetail() async {
    _isLoading = true;
    update();

    try {
      // Get chapter data from the chapters list in SubjectDetailController
      SubjectDetailController? subjectController;
      try {
        subjectController = Get.find<SubjectDetailController>();
      } catch (e) {
        logger.w('SubjectDetailController not found, using fallback data');
      }

      _chapter = subjectController?.chapters.firstWhereOrNull(
        (ch) => ch.id == chapterId,
      );

      if (_chapter != null) {
        _chapterTitle = _chapter!.name;
        _videos = _chapter!.videos.map((e) => Video.fromJson(e)).toList();
        _notes = _chapter!.notes.map((e) => Note.fromJson(e)).toList();
        _quizzes = _chapter!.quizzes.map((e) => Exam.fromJson(e)).toList();
      }
    } catch (e) {
      logger.e('Error loading chapter details: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void playVideo(int videoId) async {
    try {
      final video = _videos.firstWhereOrNull((v) => v.id == videoId);
      logger.d(video?.toJson());

      if (video != null) {
        // Check if video is downloaded
        if (!video.isDownloaded ||
            video.filePath == null ||
            video.filePath!.isEmpty) {
          Get.snackbar(
            'Video Not Available',
            'This video needs to be downloaded first to watch offline',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          return;
        }

        // Check if the file actually exists
        final file = File(video.filePath!);
        if (!await file.exists()) {
          Get.snackbar(
            'File Not Found',
            'The downloaded video file could not be found. Please download again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          // Reset download status
          video.isDownloaded = false;
          video.filePath = null;
          update();
          return;
        }

        // Use local file path for downloaded videos
        logger.d('Playing video from: ${video.filePath}');

        if (video.filePath != null) {
          logger.f('Playing video from: ${video.filePath}');
          Get.to(
            VideoPlayerScreen(
              videoId: video.id,
              videoUrl: video.filePath!, // Use local file path
              videoTitle: video.title,
            ),
          );
        }
      } else {
        Get.snackbar('Error', 'Video not found');
      }
    } catch (e) {
      logger.e('Error playing video: $e');
      Get.snackbar('Error', 'Failed to play video: $e');
    }
  }

  void openPDF(int noteId) {
    try {
      final note = _notes.firstWhereOrNull((n) => n.id == noteId);
      if (note != null) {
        String pdfUrl;

        // If note is downloaded, use local file path
        if (note.isDownloaded &&
            note.filePath != null &&
            note.filePath!.isNotEmpty) {
          final file = File(note.filePath!);
          if (file.existsSync()) {
            pdfUrl = note.filePath!;
            logger.d('Using local file path: $pdfUrl');
          } else {
            // File doesn't exist anymore, reset download status
            note.isDownloaded = false;
            note.filePath = null;
            update();
            Get.snackbar(
              'File Not Found',
              'The downloaded file could not be found. Please download again.',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            return;
          }
        } else {
          // For remote files, we need to get the actual URL from the API
          // The note.content field just contains "pdf", not the URL
          logger.e(
            'Remote PDF access not properly implemented. Note content: ${note.content}',
          );
          Get.snackbar(
            'Error',
            'Remote PDF viewing is not implemented. Please download the PDF first.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        logger.d(
          'Opening PDF with URL: $pdfUrl, Title: ${note.title}, ID: $noteId',
        );
        Get.to(
          PDFReaderScreen(pdfUrl: pdfUrl, pdfTitle: note.title, pdfId: noteId),
        );
      } else {
        Get.snackbar('Error', 'PDF not found');
      }
    } catch (e) {
      logger.e('Error opening PDF: $e');
      Get.snackbar('Error', 'Failed to open PDF');
    }
  }

  void downloadNote(int noteId) async {
    try {
      final note = _notes.firstWhereOrNull((n) => n.id == noteId);
      if (note != null) {
        // Check if already downloaded
        if (note.isDownloaded &&
            note.filePath != null &&
            note.filePath!.isNotEmpty) {
          // If it's a PDF, open it directly
          if (note.content.toLowerCase() == 'pdf') {
            openPDF(noteId);
          } else {
            // For other types, you could implement other viewers or just show success
            Get.snackbar(
              'Info',
              'Note is already downloaded and available offline',
            );
          }
          return;
        }

        // Check if already downloading
        if (note.isDownloading) {
          Get.snackbar(
            'Already Downloading',
            'This note is already being downloaded',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        // Start download process
        note.isDownloading = true;
        note.downloadProgress = 0.0;
        noteDownloadProgress[noteId] = {'progress': 0.0, 'isDownloading': true};
        update();

        Get.snackbar(
          'Downloading',
          'Starting download of ${note.title}...',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');
        await _noteApiService.downloadNote(
          noteId,
          deviceId: device.id,
          onData: (data, progress) {
            logger.d('Downloading note: $progress%');
            // Update progress in real-time
            note.downloadProgress = progress / 100.0;
            noteDownloadProgress[noteId] = {
              'progress': progress / 100.0,
              'isDownloading': true,
            };
            update();
          },
          onDone: (path) {
            logger.d('Downloaded note to: $path');

            // Verify the file exists and has content
            final file = File(path);
            if (file.existsSync() && file.lengthSync() > 0) {
              // Update note with download info
              note.filePath = path;
              note.isDownloaded = true;
              note.isDownloading = false;
              note.downloadProgress = 1.0;

              // Update progress map
              noteDownloadProgress[noteId] = {
                'progress': 1.0,
                'isDownloading': false,
              };

              // Save to storage
              _hiveNoteStorage.addDownloadedNote(noteId, path);

              // Update UI
              update();

              Get.snackbar(
                'Download Complete',
                'Note downloaded successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );

              // If it's a PDF, offer to open it
              if (note.content.toLowerCase() == 'pdf') {
                Get.snackbar(
                  'PDF Ready',
                  'Tap the note to open the downloaded PDF',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
            } else {
              logger.e('Downloaded file is empty or doesn\'t exist: $path');
              // Reset download state on error
              note.isDownloading = false;
              note.downloadProgress = 0.0;
              noteDownloadProgress.remove(noteId);
              update();

              Get.snackbar(
                'Error',
                'Downloaded file is corrupted or empty',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          onError: (error) {
            logger.e('Error downloading note: $error');
            // Reset download state on error
            note.isDownloading = false;
            note.downloadProgress = 0.0;
            noteDownloadProgress.remove(noteId);
            update();

            Get.snackbar(
              'Download Failed',
              'Failed to download note: $error',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 4),
            );
          },
        );
      } else {
        Get.snackbar('Error', 'Note not found');
      }
    } catch (e) {
      logger.e('Error downloading note: $e');
      Get.snackbar(
        'Error',
        'Failed to download note: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void startQuiz(int quizId) {
    // Get.to
  }

  void downloadVideo(int videoId) async {
    try {
      // // Check storage permission first

      final video = _videos.firstWhereOrNull((v) => v.id == videoId);
      if (video != null) {
        // Set downloading state
        video.isDownloading = true;
        video.downloadProgress = 0.0;
        update();

        final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');
        VideoApiService().downloadVideo(
          videoId,
          deviceId: device.id,
          onData: (data, progress) {
            logger.d('Downloading video: $progress%');
            // Update progress in real-time
            video.downloadProgress = progress / 100.0;
            update();
          },
          onDone: (path) {
            logger.d('Downloaded video to: $path');

            // Verify the file exists and has content
            final file = File(path);
            if (file.existsSync() && file.lengthSync() > 0) {
              HiveVideoStorage().addDownloadedVideo(videoId, path);
              video.filePath = path;
              video.isDownloaded = true;
              video.isDownloading = false;
              video.downloadProgress = 1.0;
              update();

              Get.snackbar(
                'Download Complete',
                'Video downloaded successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            } else {
              logger.e('Downloaded file is empty or doesn\'t exist: $path');
              video.isDownloading = false;
              video.downloadProgress = 0.0;
              update();
              Get.snackbar('Error', 'Downloaded file is corrupted or empty');
            }
          },
          onError: (error) {
            logger.e('Error downloading video: $error');
            // Reset downloading state on error
            video.isDownloading = false;
            video.downloadProgress = 0.0;
            update();
            Get.snackbar('Error', 'Failed to download video: $error');
          },
        );
      } else {
        Get.snackbar('Error', 'Video not found');
      }
    } catch (e) {
      logger.e('Error downloading video: $e');
      Get.snackbar('Error', 'Failed to download video: $e');
    }
  }

  // Add this method to load downloaded notes on init
  void _loadDownloadedNotes() async {
    try {
      final downloadedNotes = await _hiveNoteStorage.getDownloadedNotes();

      for (final downloadedNote in downloadedNotes) {
        final noteId = downloadedNote['id'] as int;
        final filePath = downloadedNote['file_path'] as String;

        // Find the note in current notes list
        final note = _notes.firstWhereOrNull((n) => n.id == noteId);
        if (note != null) {
          // Verify file still exists
          final file = File(filePath);
          if (file.existsSync()) {
            note.isDownloaded = true;
            note.filePath = filePath;
          } else {
            // File doesn't exist, remove from downloaded list
            downloadedNotes.removeWhere((n) => n['id'] == noteId);
            _hiveNoteStorage.setDownloadedNotes(downloadedNotes);
          }
        }
      }

      update();
    } catch (e) {
      logger.e('Error loading downloaded notes: $e');
    }
  }
}
