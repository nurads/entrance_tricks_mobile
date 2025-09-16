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
      } else {
        // Fallback to mock data if chapter not found
        _chapterTitle = 'Chapter Details';
        _videos = [
          {
            'id': 1,
            'name': 'Introduction to Motion',
            'duration': '15:30',
            'isWatched': true,
            'thumbnail': '',
            'url': '',
          },
          {
            'id': 2,
            'name': 'Newton\'s Laws of Motion',
            'duration': '22:45',
            'isWatched': false,
            'thumbnail': '',
            'url': '',
          },
        ];
        _notes = [
          {
            'id': 1,
            'name': 'Motion Formulas',
            'type': 'PDF',
            'size': '2.5 MB',
            'isDownloaded': true,
          },
          {
            'id': 2,
            'name': 'Newton\'s Laws Summary',
            'type': 'Markdown',
            'size': '1.2 MB',
            'isDownloaded': false,
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
      }

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
    Get.snackbar('Info', 'Video player will be implemented');
    // TODO: Implement video player
  }

  void downloadNote(int noteId) {
    Get.snackbar('Info', 'Note download will be implemented');
    // TODO: Implement note download
  }

  void startQuiz(int quizId) {
    Get.snackbar('Info', 'Quiz functionality will be implemented');
    // TODO: Navigate to quiz taking page
  }
}
