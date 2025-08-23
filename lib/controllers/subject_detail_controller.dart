import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';

class SubjectDetailController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _subjectName = '';
  String get subjectName => _subjectName;

  List<Map<String, dynamic>> _chapters = [];
  List<Map<String, dynamic>> get chapters => _chapters;

  int subjectId = 0;

  @override
  void onInit() {
    super.onInit();
    subjectId = Get.arguments?['subjectId'] ?? 1;
    loadSubjectDetail();
  }

  void loadSubjectDetail() async {
    _isLoading = true;
    update();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Mock data based on subject ID
      switch (subjectId) {
        case 1:
          _subjectName = 'Physics';
          _chapters = [
            {
              'id': 1,
              'title': 'Mechanics',
              'description':
                  'Learn about motion, forces, and energy in classical mechanics.',
              'videos': 8,
              'notes': 5,
              'quizzes': 3,
              'isCompleted': true,
            },
            {
              'id': 2,
              'title': 'Thermodynamics',
              'description':
                  'Understanding heat, temperature, and energy transfer.',
              'videos': 6,
              'notes': 4,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 3,
              'title': 'Waves and Sound',
              'description':
                  'Study wave properties, sound waves, and acoustics.',
              'videos': 7,
              'notes': 6,
              'quizzes': 4,
              'isCompleted': false,
            },
          ];
          break;
        case 2:
          _subjectName = 'Chemistry';
          _chapters = [
            {
              'id': 1,
              'title': 'Atomic Structure',
              'description':
                  'Learn about atoms, electrons, and periodic table.',
              'videos': 5,
              'notes': 3,
              'quizzes': 2,
              'isCompleted': true,
            },
            {
              'id': 2,
              'title': 'Chemical Bonding',
              'description':
                  'Understanding ionic, covalent, and metallic bonds.',
              'videos': 6,
              'notes': 4,
              'quizzes': 3,
              'isCompleted': false,
            },
          ];
          break;
        default:
          _subjectName = 'Subject';
          _chapters = [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subject details');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void openChapter(int chapterId) {
    Get.toNamed(
      VIEWS.chapterDetail.path,
      arguments: {'chapterId': chapterId, 'subjectId': subjectId},
    );
  }
}
