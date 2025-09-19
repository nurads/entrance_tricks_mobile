import 'package:get/get.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/controllers/subject/subject_detail_controller.dart';

class ChapterDetailController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

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
        _videos = _chapter!.videos.map((e) => Video.fromJson(e)).toList();
        _notes = _chapter!.notes.map((e) => Note.fromJson(e)).toList();
        _quizzes = _chapter!.quizzes.map((e) => Exam.fromJson(e)).toList();
      }
      // Fallback to mock data if chapter not found
      // _chapterTitle = 'Chapter Details';

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
      final video = _videos.firstWhereOrNull((v) => v.id == videoId);
      if (video != null) {
        Get.toNamed(
          VIEWS.videoPlayer.path,
          arguments: {
            'videoId': videoId,
            'videoUrl': video.file,
            'videoTitle': video.title,
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
      final note = _notes.firstWhereOrNull((n) => n.id == noteId);
      if (note != null) {
        Get.toNamed(
          VIEWS.pdfReader.path,
          arguments: {
            'pdfId': noteId,
            'pdfUrl': note.content,
            'pdfTitle': note.title,
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
      final note = _notes.firstWhereOrNull((n) => n.id == noteId);
      if (note != null) {
        // If it's a PDF, open it directly
        if (note.content.toLowerCase() == 'pdf') {
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
