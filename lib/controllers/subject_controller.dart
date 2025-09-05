import 'package:get/get.dart';
import 'package:entrance_tricks/views/subject/subject_detail.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/models/models.dart';

class SubjectController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  @override
  void onInit() {
    super.onInit();
    loadSubjects();
  }

  void loadSubjects() async {
    _isLoading = true;
    update();

    try {
      _subjects = await SubjectsService().getSubjects();
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
