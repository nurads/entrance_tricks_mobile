import 'package:get/get.dart';
import 'package:entrance_tricks/views/subject/subject_detail.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/storages/storages.dart';
import 'package:entrance_tricks/utils/device/device.dart';

class SubjectController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Grade? _grade;
  Grade? get grade => _grade;

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  final _coreService = Get.find<CoreService>();

  User? _user;

  @override
  void onInit() async {
    super.onInit();
    _grade = _coreService.authService.user.value?.grade;
    _user = await HiveUserStorage().getUser();
    HiveUserStorage().listen((event) {
      _user = event;
      loadSubjects();
    }, 'user');
    loadSubjects();
  }

  void loadSubjects() async {
    _isLoading = true;
    update();

    try {
      final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');
      _subjects = await SubjectsService().getSubjects(
        device.id,
        gradeId: _grade?.id ?? 0,
      );
      _coreService.setSubjects(_subjects);
    } catch (e) {
      _subjects = _coreService.subjects;
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
