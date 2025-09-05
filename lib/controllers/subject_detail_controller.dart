import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';

class SubjectDetailController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _subjectName = '';
  String get subjectName => _subjectName;

  List<Chapter> _chapters = [];
  List<Chapter> get chapters => _chapters;

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
      Subject subject = await SubjectsService().getSubject(subjectId);
      _subjectName = subject.title;
      _chapters = await ChaptersService().getChapters(subjectId);
    } catch (e) {
      logger.e(e);
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
