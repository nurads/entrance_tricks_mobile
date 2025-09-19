import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/controllers/home/main_navigation_controller.dart';
import 'package:entrance_tricks/controllers/misc/notifications_controller.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:entrance_tricks/utils/device/device.dart';

class HomeDashboardController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  int _notificationCount = 3;
  int get notificationCount => _notificationCount;

  final CoreService _coreService = Get.find<CoreService>();

  late DeviceInfo _deviceInfo;

  List<Map<String, dynamic>> _recentNews = [];
  List<Map<String, dynamic>> get recentNews => _recentNews;

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  @override
  void onInit() async {
    super.onInit();

    loadSubjects();
    _deviceInfo = await UserDevice.getDeviceInfo();

    InternetConnection().onStatusChange.listen((event) {
      logger.i('Internet status changed: $event');
      if (event == InternetStatus.connected) {
        loadSubjects();
      }
    });
  }

  Future<void> loadSubjects() async {
    _isLoading = true;
    update();
    if (_coreService.hasInternet) {
      try {
        logger.i('Loading subjects from api');
        final gradeId = _coreService.authService.user.value?.grade.id;

        _subjects = await SubjectsService().getSubjects(
          _deviceInfo.id,
          gradeId: gradeId ?? 0,
        );
        logger.i('Subjects: ${_deviceInfo.id}');
        final _debugSubjects = _subjects.firstWhere((e) => e.isLocked);
        logger.i('Debug subjects: $_debugSubjects ${_debugSubjects.isLocked}');
        logger.i('Debug subjects: $_debugSubjects ${_debugSubjects.isLocked}');
        _coreService.setSubjects(_subjects);
      } catch (e) {
        logger.i('Loading subjects from storage');
        logger.e(e);
        logger.i(_coreService.subjects);
        _subjects = _coreService.subjects;
      } finally {
        _isLoading = false;
        update();
      }
    } else {
      logger.i('No internet');
      _subjects = _coreService.subjects;
      logger.i(_subjects);
      _isLoading = false;
      update();
    }
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    update();

    try {
      _recentNews = [
        {
          'id': 1,
          'title': 'New Physics Chapter: Quantum Mechanics',
          'excerpt':
              'We have added comprehensive study materials for Quantum Mechanics including videos, notes, and practice questions.',
          'date': '2 days ago',
        },
        {
          'id': 2,
          'title': 'Scholarship Program 2024',
          'excerpt':
              'Applications are now open for our merit-based scholarship program. Top performers will receive up to 100% fee waiver.',
          'date': '1 week ago',
        },
        {
          'id': 3,
          'title': 'App Update: Dark Mode Available',
          'excerpt':
              'The latest app update includes dark mode, improved video player, and better offline support.',
          'date': '2 weeks ago',
        },
      ];

      _subjects = await SubjectsService().getSubjects(
        _deviceInfo.id,
        gradeId: 1,
      );
      logger.i(_subjects.map((e) => e.isLocked).toList()[0]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
      logger.e(e);
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
    Get.snackbar(
      'Refreshed',
      'Dashboard data updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openNotifications() {
    Get.to(() => NotificationsPage());
  }

  void startLearning() {
    // Navigate to subjects page (index 1 in bottom navigation)
    Get.find<MainNavigationController>().changeIndex(1);
  }

  void viewAllExams() {
    // Navigate to exams page (index 2 in bottom navigation)
    Get.find<MainNavigationController>().changeIndex(2);
  }

  void viewAllNews() {
    // Navigate to news page (index 3 in bottom navigation)
    Get.find<MainNavigationController>().changeIndex(3);
  }

  void openExam(int examId) {
    Get.snackbar('Info', 'Opening exam $examId');
    // Navigate to exam detail
  }

  void openNews(int newsId) {
    Get.snackbar('Info', 'Opening news $newsId');
    // Navigate to news detail
  }

  void selectSubject(int subjectId) {
    // Navigate to subject page for the selected grade
    Get.to(() => SubjectDetail(), arguments: {'subjectId': subjectId});
  }

  void updateNotificationCount() {
    // Recalculate notification count from notifications controller
    try {
      final notificationsController = Get.find<NotificationsController>();
      _notificationCount = notificationsController.notifications
          .where((n) => !n['isRead'])
          .length;
      update();
    } catch (e) {
      // Notifications controller not found, ignore
    }
  }
}
