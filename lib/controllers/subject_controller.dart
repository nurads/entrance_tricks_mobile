import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';

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
        {'id': 1, 'name': 'Physics', 'chapters': 15, 'videos': 125},
        {'id': 2, 'name': 'Chemistry', 'chapters': 12, 'videos': 98},
        {'id': 3, 'name': 'Mathematics', 'chapters': 18, 'videos': 156},
        {'id': 4, 'name': 'Biology', 'chapters': 20, 'videos': 187},
        {'id': 5, 'name': 'English', 'chapters': 8, 'videos': 45},
        {'id': 6, 'name': 'General Knowledge', 'chapters': 10, 'videos': 67},
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subjects');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void navigateToSubjectDetail(int subjectId) {
    Get.toNamed(VIEWS.subjectDetail.path, arguments: {'subjectId': subjectId});
  }
}
