import 'package:get/get.dart';
import 'package:entrance_tricks/views/subject/subject_detail.dart';

class SubjectController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> get subjects => _subjects;

  @override
  void onInit() {
    super.onInit();
    loadSubjects();
  }

  void loadSubjects() async {
    _isLoading = true;
    update();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      _subjects = [
        {'id': 1, 'name': 'English', 'chapters': 7, 'videos': 45},
        {'id': 2, 'name': 'Maths', 'chapters': 7, 'videos': 67},
        {'id': 3, 'name': 'Physics', 'chapters': 7, 'videos': 89},
        {'id': 4, 'name': 'Chemistry', 'chapters': 7, 'videos': 78},
        {'id': 5, 'name': 'Biology', 'chapters': 7, 'videos': 92},
        {'id': 6, 'name': 'Geography', 'chapters': 7, 'videos': 56},
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subjects');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void navigateToSubjectDetail(int subjectId) {
    // Navigate to subject detail page for the selected subject
    Get.to(() => SubjectDetail(), arguments: {'subjectId': subjectId});
  }
}
