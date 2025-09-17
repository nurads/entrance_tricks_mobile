import 'package:get/get.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:entrance_tricks/controllers/subject_detail_controller.dart';

class ChapterDetailController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _chapterTitle = '';
  String get chapterTitle => _chapterTitle;

  Chapter? _chapter;
  Chapter? get chapter => _chapter;

  List<dynamic> _videos = [];
  List<dynamic> get videos => _videos;

  List<dynamic> _notes = [];
  List<dynamic> get notes => _notes;

  List<dynamic> _quizzes = [];
  List<dynamic> get quizzes => _quizzes;

  int chapterId = 0;
  int subjectId = 0;

  @override
  void onInit() {
    super.onInit();
    chapterId = Get.arguments?['chapterId'] ?? 1;
    subjectId = Get.arguments?['subjectId'] ?? 1;
    loadChapterDetail();
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
        _videos = _chapter!.videos;
        _notes = _chapter!.notes;
        _quizzes = _chapter!.quizzes;
      }
      // Fallback to mock data if chapter not found
      // _chapterTitle = 'Chapter Details';
      _videos = [
        {
          'id': 1,
          'name': 'Introduction to Motion',
          'duration': '15:30',
          'isWatched': true,
          'thumbnail': '',
          'url':
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        },
        {
          'id': 2,
          'name': 'Newton\'s Laws of Motion',
          'duration': '22:45',
          'isWatched': false,
          'thumbnail': '',
          'url':
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        },
      ];
      _notes = [
        {
          'id': 1,
          'name': 'Motion Formulas',
          'type': 'PDF',
          'size': '2.5 MB',
          'isDownloaded': true,
          'url':
              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        },
        {
          'id': 2,
          'name': 'Newton\'s Laws Summary',
          'type': 'Markdown',
          'size': '1.2 MB',
          'isDownloaded': false,
          'url':
              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        },
      ];
      _quizzes = [
        {
          'id': 1,
          'name': 'Motion Basics Quiz',
          'questions': 10,
          'duration': 15,
          'bestScore': 85,
          'attempts': 2,
        },
        {
          'id': 2,
          'name': 'Newton\'s Laws Quiz',
          'questions': 8,
          'duration': 12,
          'bestScore': 0,
          'attempts': 0,
        },
      ];

      logger.i('Chapter loaded: $_chapterTitle');
      logger.i(
        'Videos: ${_videos.length}, Notes: ${_notes.length}, Quizzes: ${_quizzes.length}',
      );
    } catch (e) {
      logger.e('Error loading chapter details: $e');
      Get.snackbar('Error', 'Failed to load chapter details');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void playVideo(int videoId) {
    try {
      final video = _videos.firstWhereOrNull((v) => v['id'] == videoId);
      if (video != null) {
        Get.toNamed(
          '/video-player',
          arguments: {
            'videoId': videoId,
            'videoUrl': video['url'] ?? '',
            'videoTitle': video['name'] ?? 'Video',
          },
        );
      } else {
        Get.snackbar('Error', 'Video not found');
      }
    } catch (e) {
      logger.e('Error playing video: $e');
      Get.snackbar('Error', 'Failed to play video');
    }
  }

  void openPDF(int noteId) {
    try {
      final note = _notes.firstWhereOrNull((n) => n['id'] == noteId);
      if (note != null) {
        Get.toNamed(
          '/pdf-reader',
          arguments: {
            'pdfId': noteId,
            'pdfUrl': note['url'] ?? '',
            'pdfTitle': note['name'] ?? 'PDF Document',
          },
        );
      } else {
        Get.snackbar('Error', 'PDF not found');
      }
    } catch (e) {
      logger.e('Error opening PDF: $e');
      Get.snackbar('Error', 'Failed to open PDF');
    }
  }

  void downloadNote(int noteId) {
    try {
      final note = _notes.firstWhereOrNull((n) => n['id'] == noteId);
      if (note != null) {
        // If it's a PDF, open it directly
        if (note['type']?.toLowerCase() == 'pdf') {
          openPDF(noteId);
        } else {
          // For other types, show download message
          Get.snackbar('Info', 'Note download will be implemented');
        }
      } else {
        Get.snackbar('Error', 'Note not found');
      }
    } catch (e) {
      logger.e('Error downloading note: $e');
      Get.snackbar('Error', 'Failed to download note');
    }
  }

  void startQuiz(int quizId) {
    Get.snackbar('Info', 'Quiz functionality will be implemented');
    // TODO: Navigate to quiz taking page
  }
}
