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
        case 1: // English
          _subjectName = 'English';
          _chapters = [
            {
              'id': 1,
              'title': 'Chapter One',
              'description': 'English Grammar and Composition',
              'videos': 8,
              'notes': 5,
              'quizzes': 3,
              'isCompleted': true,
            },
            {
              'id': 2,
              'title': 'Chapter Two',
              'description': 'Reading Comprehension',
              'videos': 6,
              'notes': 4,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 3,
              'title': 'Chapter Three',
              'description': 'Writing Skills',
              'videos': 7,
              'notes': 6,
              'quizzes': 4,
              'isCompleted': false,
            },
            {
              'id': 4,
              'title': 'Chapter Four',
              'description': 'Literature Analysis',
              'videos': 5,
              'notes': 4,
              'quizzes': 3,
              'isCompleted': false,
            },
            {
              'id': 5,
              'title': 'Chapter Five',
              'description': 'Vocabulary Building',
              'videos': 6,
              'notes': 5,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 6,
              'title': 'Chapter Six',
              'description': 'Speaking and Listening',
              'videos': 4,
              'notes': 3,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 7,
              'title': 'Chapter Seven',
              'description': 'Exam Preparation',
              'videos': 8,
              'notes': 6,
              'quizzes': 5,
              'isCompleted': false,
            },
          ];
          break;
        case 2: // Maths
          _subjectName = 'Maths';
          _chapters = [
            {
              'id': 1,
              'title': 'Chapter One',
              'description': 'Algebra Fundamentals',
              'videos': 8,
              'notes': 5,
              'quizzes': 3,
              'isCompleted': true,
            },
            {
              'id': 2,
              'title': 'Chapter Two',
              'description': 'Geometry Basics',
              'videos': 6,
              'notes': 4,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 3,
              'title': 'Chapter Three',
              'description': 'Trigonometry',
              'videos': 7,
              'notes': 6,
              'quizzes': 4,
              'isCompleted': false,
            },
            {
              'id': 4,
              'title': 'Chapter Four',
              'description': 'Calculus Introduction',
              'videos': 5,
              'notes': 4,
              'quizzes': 3,
              'isCompleted': false,
            },
            {
              'id': 5,
              'title': 'Chapter Five',
              'description': 'Statistics and Probability',
              'videos': 6,
              'notes': 5,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 6,
              'title': 'Chapter Six',
              'description': 'Number Theory',
              'videos': 4,
              'notes': 3,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 7,
              'title': 'Chapter Seven',
              'description': 'Problem Solving',
              'videos': 8,
              'notes': 6,
              'quizzes': 5,
              'isCompleted': false,
            },
          ];
          break;
        case 3: // Physics
          _subjectName = 'Physics';
          _chapters = [
            {
              'id': 1,
              'title': 'Chapter One',
              'description': 'Physics and human society',
              'videos': 8,
              'notes': 5,
              'quizzes': 3,
              'isCompleted': true,
            },
            {
              'id': 2,
              'title': 'Chapter Two',
              'description': 'Physical quantities',
              'videos': 6,
              'notes': 4,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 3,
              'title': 'Chapter Three',
              'description': 'Motion In Straight Line',
              'videos': 7,
              'notes': 6,
              'quizzes': 4,
              'isCompleted': false,
            },
            {
              'id': 4,
              'title': 'Chapter Four',
              'description': 'Introduction to physics',
              'videos': 5,
              'notes': 4,
              'quizzes': 3,
              'isCompleted': false,
            },
            {
              'id': 5,
              'title': 'Chapter Five',
              'description': 'Introduction to physics',
              'videos': 6,
              'notes': 5,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 6,
              'title': 'Chapter Six',
              'description': 'Introduction to physics',
              'videos': 4,
              'notes': 3,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 7,
              'title': 'Chapter Seven',
              'description': 'Introduction to physics',
              'videos': 8,
              'notes': 6,
              'quizzes': 5,
              'isCompleted': false,
            },
          ];
          break;
        case 4: // Chemistry
          _subjectName = 'Chemistry';
          _chapters = [
            {
              'id': 1,
              'title': 'Chapter One',
              'description': 'Atomic Structure',
              'videos': 8,
              'notes': 5,
              'quizzes': 3,
              'isCompleted': true,
            },
            {
              'id': 2,
              'title': 'Chapter Two',
              'description': 'Chemical Bonding',
              'videos': 6,
              'notes': 4,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 3,
              'title': 'Chapter Three',
              'description': 'Chemical Reactions',
              'videos': 7,
              'notes': 6,
              'quizzes': 4,
              'isCompleted': false,
            },
            {
              'id': 4,
              'title': 'Chapter Four',
              'description': 'Organic Chemistry',
              'videos': 5,
              'notes': 4,
              'quizzes': 3,
              'isCompleted': false,
            },
            {
              'id': 5,
              'title': 'Chapter Five',
              'description': 'Inorganic Chemistry',
              'videos': 6,
              'notes': 5,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 6,
              'title': 'Chapter Six',
              'description': 'Physical Chemistry',
              'videos': 4,
              'notes': 3,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 7,
              'title': 'Chapter Seven',
              'description': 'Analytical Chemistry',
              'videos': 8,
              'notes': 6,
              'quizzes': 5,
              'isCompleted': false,
            },
          ];
          break;
        case 5: // Biology
          _subjectName = 'Biology';
          _chapters = [
            {
              'id': 1,
              'title': 'Chapter One',
              'description': 'Cell Biology',
              'videos': 8,
              'notes': 5,
              'quizzes': 3,
              'isCompleted': true,
            },
            {
              'id': 2,
              'title': 'Chapter Two',
              'description': 'Genetics',
              'videos': 6,
              'notes': 4,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 3,
              'title': 'Chapter Three',
              'description': 'Ecology',
              'videos': 7,
              'notes': 6,
              'quizzes': 4,
              'isCompleted': false,
            },
            {
              'id': 4,
              'title': 'Chapter Four',
              'description': 'Evolution',
              'videos': 5,
              'notes': 4,
              'quizzes': 3,
              'isCompleted': false,
            },
            {
              'id': 5,
              'title': 'Chapter Five',
              'description': 'Human Biology',
              'videos': 6,
              'notes': 5,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 6,
              'title': 'Chapter Six',
              'description': 'Plant Biology',
              'videos': 4,
              'notes': 3,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 7,
              'title': 'Chapter Seven',
              'description': 'Microbiology',
              'videos': 8,
              'notes': 6,
              'quizzes': 5,
              'isCompleted': false,
            },
          ];
          break;
        case 6: // Geography
          _subjectName = 'Geography';
          _chapters = [
            {
              'id': 1,
              'title': 'Chapter One',
              'description': 'Physical Geography',
              'videos': 8,
              'notes': 5,
              'quizzes': 3,
              'isCompleted': true,
            },
            {
              'id': 2,
              'title': 'Chapter Two',
              'description': 'Human Geography',
              'videos': 6,
              'notes': 4,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 3,
              'title': 'Chapter Three',
              'description': 'Economic Geography',
              'videos': 7,
              'notes': 6,
              'quizzes': 4,
              'isCompleted': false,
            },
            {
              'id': 4,
              'title': 'Chapter Four',
              'description': 'Political Geography',
              'videos': 5,
              'notes': 4,
              'quizzes': 3,
              'isCompleted': false,
            },
            {
              'id': 5,
              'title': 'Chapter Five',
              'description': 'Environmental Geography',
              'videos': 6,
              'notes': 5,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 6,
              'title': 'Chapter Six',
              'description': 'Regional Geography',
              'videos': 4,
              'notes': 3,
              'quizzes': 2,
              'isCompleted': false,
            },
            {
              'id': 7,
              'title': 'Chapter Seven',
              'description': 'Geographic Information Systems',
              'videos': 8,
              'notes': 6,
              'quizzes': 5,
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
