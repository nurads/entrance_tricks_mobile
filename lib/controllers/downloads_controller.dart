import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadsController extends GetxController {
  // Observable lists for downloaded content
  final RxList<Map<String, dynamic>> downloadedVideos =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> downloadedExams =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> downloadedNotes =
      <Map<String, dynamic>>[].obs;

  // Loading states
  final RxBool isLoadingVideos = false.obs;
  final RxBool isLoadingExams = false.obs;
  final RxBool isLoadingNotes = false.obs;

  // Storage info
  final RxDouble usedStorage = 0.0.obs;
  final RxDouble totalStorage = 5.0.obs; // 5GB total storage

  @override
  void onInit() {
    super.onInit();
    loadDownloadedContent();
  }

  // Load all downloaded content
  Future<void> loadDownloadedContent() async {
    await Future.wait([
      loadDownloadedVideos(),
      loadDownloadedExams(),
      loadDownloadedNotes(),
    ]);
    calculateStorageUsage();
  }

  // Load downloaded videos
  Future<void> loadDownloadedVideos() async {
    try {
      isLoadingVideos.value = true;

      // Simulate API call - replace with actual implementation
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - replace with actual data from local storage
      downloadedVideos.value = [
        {
          'id': 1,
          'title': 'Introduction to Mathematics',
          'subject': 'Mathematics',
          'size': 45.2,
          'duration': '25:30',
          'filePath': '/storage/videos/math_intro.mp4',
          'downloadedAt': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'id': 2,
          'title': 'Physics Fundamentals',
          'subject': 'Physics',
          'size': 67.8,
          'duration': '32:15',
          'filePath': '/storage/videos/physics_fundamentals.mp4',
          'downloadedAt': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'id': 3,
          'title': 'Chemistry Basics',
          'subject': 'Chemistry',
          'size': 52.1,
          'duration': '28:45',
          'filePath': '/storage/videos/chemistry_basics.mp4',
          'downloadedAt': DateTime.now().subtract(const Duration(hours: 5)),
        },
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load downloaded videos: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingVideos.value = false;
    }
  }

  // Load downloaded exams
  Future<void> loadDownloadedExams() async {
    try {
      isLoadingExams.value = true;

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data
      downloadedExams.value = [
        {
          'id': 1,
          'name': 'Mathematics Practice Test 1',
          'subject': 'Mathematics',
          'duration': 60,
          'questions': 25,
          'size': 2.3,
          'filePath': '/storage/exams/math_test_1.json',
          'downloadedAt': DateTime.now().subtract(const Duration(days: 3)),
        },
        {
          'id': 2,
          'name': 'Physics Mock Exam',
          'subject': 'Physics',
          'duration': 90,
          'questions': 40,
          'size': 3.1,
          'filePath': '/storage/exams/physics_mock.json',
          'downloadedAt': DateTime.now().subtract(const Duration(days: 1)),
        },
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load downloaded exams: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingExams.value = false;
    }
  }

  // Load downloaded notes
  Future<void> loadDownloadedNotes() async {
    try {
      isLoadingNotes.value = true;

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data
      downloadedNotes.value = [
        {
          'id': 1,
          'title': 'Mathematics Formulas',
          'subject': 'Mathematics',
          'type': 'pdf',
          'size': 1.8,
          'filePath': '/storage/notes/math_formulas.pdf',
          'downloadedAt': DateTime.now().subtract(const Duration(days: 4)),
        },
        {
          'id': 2,
          'title': 'Physics Laws and Principles',
          'subject': 'Physics',
          'type': 'pdf',
          'size': 2.5,
          'filePath': '/storage/notes/physics_laws.pdf',
          'downloadedAt': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'id': 3,
          'title': 'Chemistry Periodic Table',
          'subject': 'Chemistry',
          'type': 'docx',
          'size': 0.9,
          'filePath': '/storage/notes/chemistry_periodic.docx',
          'downloadedAt': DateTime.now().subtract(const Duration(hours: 12)),
        },
        {
          'id': 4,
          'title': 'Biology Study Guide',
          'subject': 'Biology',
          'type': 'pdf',
          'size': 3.2,
          'filePath': '/storage/notes/biology_guide.pdf',
          'downloadedAt': DateTime.now().subtract(const Duration(hours: 6)),
        },
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load downloaded notes: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingNotes.value = false;
    }
  }

  // Calculate storage usage
  void calculateStorageUsage() {
    double totalSize = 0.0;

    // Calculate video sizes
    for (var video in downloadedVideos) {
      totalSize += (video['size'] ?? 0.0);
    }

    // Calculate exam sizes
    for (var exam in downloadedExams) {
      totalSize += (exam['size'] ?? 0.0);
    }

    // Calculate note sizes
    for (var note in downloadedNotes) {
      totalSize += (note['size'] ?? 0.0);
    }

    usedStorage.value = totalSize;
  }

  // Play video
  void playVideo(int videoId) {
    final video = downloadedVideos.firstWhereOrNull((v) => v['id'] == videoId);
    if (video != null) {
      // Navigate to video player with local file
      Get.snackbar(
        'Info',
        'Playing video: ${video['title']}',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      // TODO: Implement video player navigation
    }
  }

  // Start exam
  void startExam(int examId) {
    final exam = downloadedExams.firstWhereOrNull((e) => e['id'] == examId);
    if (exam != null) {
      Get.snackbar(
        'Info',
        'Starting exam: ${exam['name']}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // TODO: Implement exam navigation
    }
  }

  // Open note
  void openNote(int noteId) {
    final note = downloadedNotes.firstWhereOrNull((n) => n['id'] == noteId);
    if (note != null) {
      Get.snackbar(
        'Info',
        'Opening note: ${note['title']}',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      // TODO: Implement note viewer navigation
    }
  }

  // Delete video
  void deleteVideo(int videoId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Video'),
        content: const Text('Are you sure you want to delete this video?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              downloadedVideos.removeWhere((v) => v['id'] == videoId);
              calculateStorageUsage();
              Get.back();
              Get.snackbar(
                'Success',
                'Video deleted successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Delete exam
  void deleteExam(int examId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Exam'),
        content: const Text('Are you sure you want to delete this exam?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              downloadedExams.removeWhere((e) => e['id'] == examId);
              calculateStorageUsage();
              Get.back();
              Get.snackbar(
                'Success',
                'Exam deleted successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Delete note
  void deleteNote(int noteId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              downloadedNotes.removeWhere((n) => n['id'] == noteId);
              calculateStorageUsage();
              Get.back();
              Get.snackbar(
                'Success',
                'Note deleted successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
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
            onPressed: () {
              downloadedVideos.clear();
              downloadedExams.clear();
              downloadedNotes.clear();
              calculateStorageUsage();
              Get.back();
              Get.snackbar(
                'Success',
                'All downloads cleared successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  // Get storage usage percentage
  double get storageUsagePercentage =>
      (usedStorage.value / totalStorage.value).clamp(0.0, 1.0);

  // Get formatted storage info
  String get formattedStorageInfo {
    return '${usedStorage.value.toStringAsFixed(1)} GB / ${totalStorage.value} GB';
  }
}
