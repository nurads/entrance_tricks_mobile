import 'package:entrance_tricks/utils/utils.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/views/exam/exam_detail_page.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/utils/storages/storages.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:entrance_tricks/utils/device/device.dart';

class ExamController extends GetxController {
  final ExamService _examService = ExamService();
  final HiveExamStorage _hiveExamStorage = HiveExamStorage();
  final CoreService _coreService = Get.find<CoreService>();
  final InternetConnection _internetConnection = InternetConnection();
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  final Subject _allPlaceholderSubject = Subject(
    id: 0,
    name: 'All',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  List<Exam> _exams = [];
  List<Exam> get exams => _exams;

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  int _selectedSubjectIndex = 0;
  int get selectedSubjectIndex => _selectedSubjectIndex;

  String? _error;
  String? get error => _error;

  @override
  void onInit() {
    super.onInit();
    loadExams();
    loadSubjects();

    _internetConnection.onStatusChange.listen((event) {
      if (event == InternetStatus.connected) {
        loadExams();
      }
    });
  }

  Future<void> loadSubjects() async {
    _subjects = [_allPlaceholderSubject, ..._coreService.subjects];
    update();
  }

  Future<void> loadExams() async {
    _isLoading = true;
    _error = null;
    update();

    final device = await UserDevice.getDeviceInfo();

    if (_coreService.hasInternet) {
      try {
        _exams = await _examService.getAvailableExams(device.id);
        await _hiveExamStorage.setExams(_exams);
      } catch (e) {
        _exams = await _hiveExamStorage.getExams();
      } finally {
        _isLoading = false;
        update();
      }
    } else {
      _exams = await _hiveExamStorage.getExams();
      logger.i(_exams);
      _isLoading = false;
      update();
    }
  }

  Future<void> selectSubject(int index) async {
    final subject = _subjects[index];
    _selectedSubjectIndex = index;
    final exams = await _hiveExamStorage.getExams();
    if (subject.id == 0) {
      _exams = exams;
    } else {
      _exams = exams.where((e) => e.subject?.id == subject.id).toList();
    }
    update();
  }

  void startExam(int examId) {
    // Navigate to exam detail page
    Get.to(() => ExamDetailPage(), arguments: {'examId': examId});
  }

  void navigateToExamDetail(int examId) {
    // Navigate to exam detail page
    Get.to(() => ExamDetailPage(), arguments: {'examId': examId});
  }

  Future<void> refreshExams() async {
    await loadExams();
  }
}
