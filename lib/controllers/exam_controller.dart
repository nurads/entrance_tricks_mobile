import 'package:get/get.dart';

class ExamController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _exams = [];
  List<Map<String, dynamic>> get exams => _exams;

  @override
  void onInit() {
    super.onInit();
    loadExams();
  }

  void loadExams() async {
    _isLoading = true;
    update();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      _exams = [
        {
          'id': 1,
          'title': 'Physics Mock Test 1',
          'duration': 60,
          'questions': 30,
          'bestScore': 85,
        },
        {
          'id': 2,
          'title': 'Chemistry Mock Test 1',
          'duration': 45,
          'questions': 25,
          'bestScore': 78,
        },
        {
          'id': 3,
          'title': 'Mathematics Mock Test 1',
          'duration': 90,
          'questions': 40,
          'bestScore': 92,
        },
        {
          'id': 4,
          'title': 'Biology Mock Test 1',
          'duration': 60,
          'questions': 35,
          'bestScore': 0, // Not taken yet
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load exams');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void navigateToExamDetail(int examId) {
    // Navigate to exam detail page
    Get.snackbar('Info', 'Exam detail page will be implemented');
  }
}
