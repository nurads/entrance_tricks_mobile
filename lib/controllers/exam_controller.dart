import 'package:get/get.dart';
import 'package:entrance_tricks/views/exam/exam_detail_page.dart';

class ExamController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _exams = [];
  List<Map<String, dynamic>> get exams => _exams;

  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> get subjects => _subjects;

  int _selectedSubjectIndex = 0;
  int get selectedSubjectIndex => _selectedSubjectIndex;

  @override
  void onInit() {
    super.onInit();
    loadExams();
    loadSubjects();
  }

  Future<void> loadExams() async {
    _isLoading = true;
    update();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      _exams = [
        {
          'id': 1,
          'title': 'Maths Exam One',
          'subject': 'Maths',
          'questions': 30,
          'duration': 75,
          'bestScore': 85,
        },
        {
          'id': 2,
          'title': 'Maths Exam Two',
          'subject': 'Maths',
          'questions': 60,
          'duration': 75,
          'bestScore': 78,
        },
        {
          'id': 3,
          'title': 'Maths Exam Three',
          'subject': 'Maths',
          'questions': 40,
          'duration': 60,
          'bestScore': 92,
        },
        {
          'id': 4,
          'title': 'English Exam One',
          'subject': 'English',
          'questions': 25,
          'duration': 45,
          'bestScore': 88,
        },
        {
          'id': 5,
          'title': 'Physics Exam One',
          'subject': 'Physics',
          'questions': 35,
          'duration': 60,
          'bestScore': 76,
        },
        {
          'id': 6,
          'title': 'Chemistry Exam One',
          'subject': 'Chemistry',
          'questions': 30,
          'duration': 50,
          'bestScore': 82,
        },
        {
          'id': 7,
          'title': 'Biology Exam One',
          'subject': 'Biology',
          'questions': 40,
          'duration': 65,
          'bestScore': 79,
        },
        {
          'id': 8,
          'title': 'Geography Exam One',
          'subject': 'Geography',
          'questions': 20,
          'duration': 30,
          'bestScore': 85,
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load exams');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> loadSubjects() async {
    try {
      _subjects = [
        {'id': 1, 'name': 'Maths'},
        {'id': 2, 'name': 'English'},
        {'id': 3, 'name': 'Physics'},
        {'id': 4, 'name': 'Biology'},
        {'id': 5, 'name': 'Chemistry'},
        {'id': 6, 'name': 'Geography'},
      ];
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subjects');
    }
  }

  void selectSubject(int index) {
    _selectedSubjectIndex = index;
    update();
  }

  List<Map<String, dynamic>> getFilteredExams() {
    if (_selectedSubjectIndex == 0) {
      return _exams; // Show all exams
    }

    final selectedSubject = _subjects[_selectedSubjectIndex]['name'];
    return _exams.where((exam) => exam['subject'] == selectedSubject).toList();
  }

  void startExam(int examId) {
    // Navigate to exam detail page
    Get.to(() => ExamDetailPage(), arguments: {'examId': examId});
  }

  void navigateToExamDetail(int examId) {
    // Navigate to exam detail page
    Get.to(() => ExamDetailPage(), arguments: {'examId': examId});
  }
}
