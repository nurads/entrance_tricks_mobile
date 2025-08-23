import 'package:get/get.dart';

class ChapterDetailController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _chapterTitle = '';
  String get chapterTitle => _chapterTitle;

  Map<String, dynamic> _chapterData = {};
  Map<String, dynamic> get chapterData => _chapterData;

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
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Mock data
      _chapterTitle = 'Mechanics - Chapter 1';
      _chapterData = {
        'id': chapterId,
        'title': _chapterTitle,
        'description':
            'Learn the fundamentals of mechanics including motion, forces, and energy.',
        'videos': [
          {
            'id': 1,
            'title': 'Introduction to Motion',
            'duration': '15:30',
            'isLocked': false,
            'isWatched': true,
            'thumbnail': '',
          },
          {
            'id': 2,
            'title': 'Newton\'s Laws of Motion',
            'duration': '22:45',
            'isLocked': false,
            'isWatched': false,
            'thumbnail': '',
          },
          {
            'id': 3,
            'title': 'Work and Energy',
            'duration': '18:20',
            'isLocked': true,
            'isWatched': false,
            'thumbnail': '',
          },
        ],
        'notes': [
          {
            'id': 1,
            'title': 'Motion Formulas',
            'type': 'PDF',
            'size': '2.5 MB',
            'isDownloaded': true,
          },
          {
            'id': 2,
            'title': 'Newton\'s Laws Summary',
            'type': 'Markdown',
            'size': '1.2 MB',
            'isDownloaded': false,
          },
          {
            'id': 3,
            'title': 'Energy Conservation',
            'type': 'PDF',
            'size': '3.1 MB',
            'isDownloaded': false,
          },
        ],
        'quizzes': [
          {
            'id': 1,
            'title': 'Motion Basics Quiz',
            'questions': 10,
            'duration': 15,
            'bestScore': 85,
            'attempts': 2,
          },
          {
            'id': 2,
            'title': 'Newton\'s Laws Quiz',
            'questions': 8,
            'duration': 12,
            'bestScore': 0,
            'attempts': 0,
          },
        ],
      };
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chapter details');
    } finally {
      _isLoading = false;
      update();
    }
  }
}
