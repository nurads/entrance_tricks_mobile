import 'package:get/get.dart';
import 'package:entrance_tricks/views/subject/subject_detail.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/storages/storages.dart';
import 'package:entrance_tricks/utils/device/device.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:async';

class SubjectController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Grade? _grade;
  Grade? get grade => _grade;

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  User? _user;
  late StreamSubscription<InternetStatus> _internetStatusSubscription;
  @override
  void onInit() async {
    super.onInit();
    _grade = _user?.grade;
    _user = await HiveUserStorage().getUser();
    HiveUserStorage().listen((event) {
      _user = event;
      loadSubjects();
      update();
    }, 'user');
    loadSubjects();
    _internetStatusSubscription = InternetConnection().onStatusChange.listen((
      event,
    ) {
      if (event == InternetStatus.connected) {
        loadSubjects();
      }
    });
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
      await HiveSubjectsStorage().write('subjects', _subjects);
    } catch (e) {
      _subjects = await HiveSubjectsStorage().read('subjects');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void navigateToSubjectDetail(int subjectId) {
    // Navigate to subject detail page for the selected subject
    Get.to(() => SubjectDetail(), arguments: {'subjectId': subjectId});
  }

  @override
  void dispose() {
    _internetStatusSubscription.cancel();
    super.dispose();
  }
}
