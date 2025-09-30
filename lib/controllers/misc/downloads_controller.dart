import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:entrance_tricks/utils/storages/storages.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/utils/device/device.dart';
import 'dart:io';
import 'package:entrance_tricks/views/common/video_player_screen.dart';
import 'package:entrance_tricks/views/common/pdf_reader_screen.dart';
import 'package:entrance_tricks/views/exam/exam_detail_page.dart';
import 'package:entrance_tricks/controllers/exam/exam_controller.dart';

class DownloadsController extends GetxController {
  // API Services
  final VideoApiService _videoApiService = VideoApiService();
  final NoteService _noteApiService = NoteService();
  final ExamService _examApiService = ExamService();
  // Storage services
  final HiveVideoStorage _videoStorage = HiveVideoStorage();
  final HiveNoteStorage _noteStorage = HiveNoteStorage();
  final HiveExamStorage _examStorage = HiveExamStorage();

  // Observable lists for all content (both downloaded and available)
  final RxList<Video> allVideos = <Video>[].obs;
  final RxList<Exam> allExams = <Exam>[].obs;
  final RxList<Note> allNotes = <Note>[].obs;

  // Loading states
  bool isLoadingVideos = false;
  bool isLoadingExams = false;
  bool isLoadingNotes = false;

  User? _user;

  @override
  void onInit() async {
    super.onInit();
    loadAllVideos();
    _user = await HiveUserStorage().getUser();
    HiveUserStorage().listen((event) {
      _user = event;
      loadAllVideos();
      loadAllExams();
      loadAllNotes();
    }, 'user');
    loadAllExams();
    loadAllNotes();
  }

  // Load all videos with download states
  Future<void> loadAllVideos() async {
    try {
      isLoadingVideos = true;
      update();

      final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');
      final grade = _user?.grade;
      // This is a simplified approach - you might need to modify based on your API structure
      try {
        // Get videos from multiple chapters or subjects
        final videos = await _videoApiService.getAllVideos(
          gradeId: grade?.id ?? 0,
          deviceId: device.id,
        );
        _videoStorage.setAllVideos(videos);
      } catch (e) {
        logger.e('Error loading videos from chapter: $e');
      }

      allVideos.value = await _videoStorage.getAllVideos();
    } catch (e) {
      allVideos.value = await _videoStorage.getAllVideos();
    } finally {
      isLoadingVideos = false;
      update();
    }
  }

  // Load all exams with download states
  Future<void> loadAllExams() async {
    try {
      isLoadingExams = true;
      update();

      final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');

      final grade = _user?.grade;

      // Get all available exams
      final exams = await _examApiService.getAvailableExams(
        device.id,
        gradeId: grade?.id,
      );

      await _examStorage.setExams(exams);

      allExams.value = await _examStorage.getExams();
    } catch (e) {
      allExams.value = await _examStorage.getExams();
    } finally {
      isLoadingExams = false;
      update();
    }
  }

  // Load all notes with download states
  Future<void> loadAllNotes() async {
    final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');

    try {
      isLoadingNotes = true;
      update();
      final grade = _user?.grade;

      List<Note> notes_ = await _noteApiService.getAllNotes(
        device.id,
        gradeId: grade?.id,
      );
      await _noteStorage.setAllNotes(notes_);

      allNotes.value = await _noteStorage.getAllNotes();
    } catch (e) {
      allNotes.value = await _noteStorage.getAllNotes();
    } finally {
      isLoadingNotes = false;
      update();
    }
  }

  // Download video
  Future<void> downloadVideo(Video video) async {
    if (video.isDownloaded) {
      Get.snackbar('Info', 'Video is already downloaded');
      return;
    }

    if (video.isDownloading) {
      Get.snackbar('Info', 'Video is already being downloaded');
      return;
    }

    try {
      video.isDownloading = true;
      video.downloadProgress = 0.0;
      update();

      final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');

      await _videoApiService.downloadVideo(
        video.id,
        deviceId: device.id,
        onData: (data, progress) {
          video.downloadProgress = progress / 100.0;
          update();
        },
        onDone: (path) {
          video.filePath = path;
          video.isDownloaded = true;
          video.isDownloading = false;
          video.downloadProgress = 1.0;

          _videoStorage.addDownloadedVideo(video.id, path);
          update();

          Get.snackbar(
            'Success',
            'Video downloaded successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        onError: (error) {
          video.isDownloading = false;
          video.downloadProgress = 0.0;
          update();

          Get.snackbar('Error', 'Failed to download video');
        },
      );
    } catch (e) {
      video.isDownloading = false;
      video.downloadProgress = 0.0;
      update();

      Get.snackbar('Error', 'Failed to download video');
    }
  }

  // Download note
  Future<void> downloadNote(Note note) async {
    if (note.isDownloaded) {
      Get.snackbar('Info', 'Note is already downloaded');
      return;
    }

    if (note.isDownloading) {
      Get.snackbar('Info', 'Note is already being downloaded');
      return;
    }

    try {
      note.isDownloading = true;
      note.downloadProgress = 0.0;
      update();

      final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');

      await _noteApiService.downloadNote(
        note.id,
        deviceId: device.id,
        onData: (data, progress) {
          note.downloadProgress = progress / 100.0;
          update();
        },
        onDone: (path) {
          note.filePath = path;
          note.isDownloaded = true;
          note.isDownloading = false;
          note.downloadProgress = 1.0;

          _noteStorage.addDownloadedNote(note.id, path);
          update();

          Get.snackbar(
            'Success',
            'Note downloaded successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        onError: (error) {
          note.isDownloading = false;
          note.downloadProgress = 0.0;
          update();

          Get.snackbar('Error', 'Failed to download note');
        },
      );
    } catch (e) {
      note.isDownloading = false;
      note.downloadProgress = 0.0;
      update();

      Get.snackbar('Error', 'Failed to download note');
    }
  }

  // Download exam (download questions)
  Future<void> downloadExam(Exam exam) async {
    if (exam.isLocked) {
      Get.snackbar(
        'Access Denied',
        'This exam is locked and cannot be downloaded',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (exam.isDownloaded) {
      Get.snackbar('Info', 'Exam is already downloaded');
      return;
    }

    if (exam.isLoadingQuestion) {
      Get.snackbar('Info', 'Exam is already being downloaded');
      return;
    }

    try {
      exam.isLoadingQuestion = true;
      update();

      final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');
      final questions = await _examApiService.getQuestions(device.id, exam.id);
      logger.d(questions);

      exam.questions = questions;
      exam.isDownloaded = true;
      exam.isLoadingQuestion = false;

      update();

      await _examStorage.setQuestions(exam.id, questions);

      Get.snackbar(
        'Success',
        'Exam downloaded successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh exam controller if it exists
      if (Get.isRegistered<ExamController>()) {
        Get.find<ExamController>().refreshExamDownloadStatus();
      }
    } catch (e) {
      exam.isLoadingQuestion = false;
      update();

      logger.e(e);
      Get.snackbar('Error', 'Failed to download exam');
    }
  }

  // Play/Open video
  void playVideo(Video video) {
    if (!video.isDownloaded || video.filePath == null) {
      Get.snackbar('Error', 'Video not downloaded');
      return;
    }

    // Navigate to video player
    Get.to(
      () => VideoPlayerScreen(
        videoUrl: video.filePath!,
        videoTitle: video.title,
        videoId: video.id,
      ),
    );
  }

  // Open note
  void openNote(Note note) {
    if (!note.isDownloaded || note.filePath == null) {
      Get.snackbar('Error', 'Note not downloaded');
      return;
    }

    // Navigate to PDF reader or appropriate viewer

    if (note.filePath != null) {
      Get.to(
        () => PDFReaderScreen(
          pdfUrl: note.filePath!,
          pdfTitle: note.title,
          pdfId: note.id,
        ),
      );
    }
  }

  // Start exam
  void startExam(Exam exam) {
    if (!exam.isDownloaded || exam.questions.isEmpty) {
      Get.snackbar('Error', 'Exam not downloaded');
      return;
    }

    // Navigate to exam screen

    Get.to(() => ExamDetailPage(exam: exam));
  }

  // Delete video
  void deleteVideo(Video video) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Video'),
        content: Text('Are you sure you want to delete "${video.title}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                // Delete file from storage
                if (video.filePath != null) {
                  final file = File(video.filePath!);
                  if (file.existsSync()) {
                    await file.delete();
                  }
                }

                // Remove from local storage
                await _videoStorage.removeDownloadedVideo(video.id);

                // Update video state
                video.isDownloaded = false;
                video.filePath = null;
                video.downloadProgress = 0.0;

                update();

                Get.back();
                Get.snackbar(
                  'Success',
                  'Video deleted successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.back();
                Get.snackbar('Error', 'Failed to delete video');
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Delete note
  void deleteNote(Note note) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                // Delete file from storage
                if (note.filePath != null) {
                  final file = File(note.filePath!);
                  if (file.existsSync()) {
                    await file.delete();
                  }
                }

                // Remove from local storage
                await _noteStorage.removeDownloadedNote(note.id);

                // Update note state
                note.isDownloaded = false;
                note.filePath = null;
                note.downloadProgress = 0.0;

                update();

                Get.back();
                Get.snackbar(
                  'Success',
                  'Note deleted successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.back();
                Get.snackbar('Error', 'Failed to delete note');
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Delete exam
  void deleteExam(Exam exam) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Exam'),
        content: Text('Are you sure you want to delete "${exam.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                // Remove from local storage
                await _examStorage.removeDownloadedExam(exam.id);

                // Update exam state
                exam.isDownloaded = false;
                exam.questions.clear();

                update();

                Get.back();
                Get.snackbar(
                  'Success',
                  'Exam deleted successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.back();
                Get.snackbar('Error', 'Failed to delete exam');
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Clear all downloads
  void clearAllDownloads() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Downloads'),
        content: const Text(
          'Are you sure you want to delete all downloaded content? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                // Delete all video files
                for (var video in allVideos.where((v) => v.isDownloaded)) {
                  if (video.filePath != null) {
                    final file = File(video.filePath!);
                    if (file.existsSync()) {
                      await file.delete();
                    }
                  }
                  video.isDownloaded = false;
                  video.filePath = null;
                  video.downloadProgress = 0.0;
                }

                // Delete all note files
                for (var note in allNotes.where((n) => n.isDownloaded)) {
                  if (note.filePath != null) {
                    final file = File(note.filePath!);
                    if (file.existsSync()) {
                      await file.delete();
                    }
                  }
                  note.isDownloaded = false;
                  note.filePath = null;
                  note.downloadProgress = 0.0;
                }

                // Clear exam downloads
                for (var exam in allExams.where((e) => e.isDownloaded)) {
                  exam.isDownloaded = false;
                  exam.questions.clear();
                }

                // Clear all storage
                await _videoStorage.removeAllDownloadedVideos();
                await _noteStorage.removeAllDownloadedNotes();
                await _examStorage.removeAllDownloadedExams();

                update();

                Get.back();
                Get.snackbar(
                  'Success',
                  'All downloads cleared successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.back();
                Get.snackbar('Error', 'Failed to clear downloads');
              }
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  // Get downloaded videos
  List<Video> get downloadedVideos =>
      allVideos.where((v) => v.isDownloaded).toList();

  // Get downloaded exams
  List<Exam> get downloadedExams =>
      allExams.where((e) => e.isDownloaded).toList();

  // Get downloaded notes
  List<Note> get downloadedNotes =>
      allNotes.where((n) => n.isDownloaded).toList();

  // Refresh all content
  Future<void> refreshContent() async {
    await loadAllVideos();
    await loadAllExams();
    await loadAllNotes();
  }
}
