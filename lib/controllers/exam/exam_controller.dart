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
  final InternetConnection _internetConnection = InternetConnection();
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  User? _user;
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
  bool hasInternet = false;

  @override
  void onInit() async {
    super.onInit();
    loadExams();
    loadSubjects();

    _user = await HiveUserStorage().getUser();

    HiveUserStorage().listen((event) {
      _user = event;
      loadExams();
    }, 'user');

    _internetConnection.onStatusChange.listen((event) {
      hasInternet = event == InternetStatus.connected;
      if (event == InternetStatus.connected) {
        loadExams();
      }
    });

    _hiveExamStorage.listen((event) {
      _exams = event.where((e) => e.examType != 'quiz').toList();
      update();
    }, 'exams');

    HiveSubjectsStorage().listen((event) {
      _subjects = [_allPlaceholderSubject, ...event];
      update();
    }, 'subjects');
  }

  Future<void> loadSubjects() async {
    final subjects = await HiveSubjectsStorage().read('subjects');
    _subjects = [_allPlaceholderSubject, ...subjects];
    update();
  }

  Future<void> loadExams() async {
    _isLoading = true;
    _error = null;
    update();

    final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');

    if (hasInternet) {
      try {
        final grade = _user?.grade;
        final exams_ = await _examService.getAvailableExams(
          device.id,
          gradeId: grade?.id,
        );
        await _hiveExamStorage.setExams(exams_);
        _exams = (await _hiveExamStorage.getExams())
            .where((e) => e.examType != 'quiz')
            .toList();
      } catch (e) {
        _exams = await _hiveExamStorage.getExams();
      } finally {
        _isLoading = false;
        update();
      }
    } else {
      _exams = (await _hiveExamStorage.getExams())
          .where((e) => e.examType != 'quiz')
          .toList();
      logger.i(_exams);
      _isLoading = false;
      update();
    }

    // Update download status for all exams
    await _updateExamDownloadStatus();
  }

  Future<void> _updateExamDownloadStatus() async {
    for (var exam in _exams) {
      final questions = await _hiveExamStorage.getQuestions(exam.id);
      exam.isDownloaded = questions.isNotEmpty;
    }
    update();
  }

  Future<void> selectSubject(int index) async {
    final subject = _subjects[index];
    _selectedSubjectIndex = index;
    final exams = await _hiveExamStorage.getExams();
    if (subject.id == 0) {
      _exams = exams.where((e) => e.examType != 'quiz').toList();
    } else {
      _exams = exams
          .where((e) => e.subject?.id == subject.id && e.examType != 'quiz')
          .toList();
    }
    // Update download status for filtered exams
    await _updateExamDownloadStatus();
  }

  void startExam(int examId) {
    // Navigate to exam detail page
    Get.to(
      () => ExamDetailPage(exam: _exams.firstWhere((e) => e.id == examId)),
    );
  }

  void navigateToExamDetail(int examId) {
    // Navigate to exam detail page
    Get.to(
      () => ExamDetailPage(exam: _exams.firstWhere((e) => e.id == examId)),
    );
  }

  Future<void> refreshExams() async {
    await loadExams();
  }

  Future<void> refreshExamDownloadStatus() async {
    await _updateExamDownloadStatus();
  }

  Future<List<Exam>> searchExams(String query) async {
    return _exams
        .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
