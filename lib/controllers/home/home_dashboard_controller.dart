import 'package:vector_academy/utils/storages/storages.dart';
import 'package:get/get.dart';
import 'package:vector_academy/views/views.dart';
import 'package:vector_academy/controllers/home/main_navigation_controller.dart';
import 'package:vector_academy/controllers/misc/notifications_controller.dart';
import 'package:vector_academy/models/models.dart';
import 'package:vector_academy/services/services.dart';
import 'package:vector_academy/utils/utils.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:vector_academy/utils/device/device.dart';

class HomeDashboardController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  int _notificationCount = 3;
  int get notificationCount => _notificationCount;

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;
  User? _user;

  @override
  void onInit() async {
    super.onInit();

    _user = await HiveUserStorage().getUser();
    loadSubjects();

    InternetConnection().onStatusChange.listen((event) {
      logger.i('Internet status changed: $event');
      if (event == InternetStatus.connected) {
        loadSubjects();
      }
    });

    HiveUserStorage().listen((event) {
      _user = event;
      loadSubjects();
      update();
    }, 'user');
  }

  Future<void> loadSubjects() async {
    _isLoading = true;
    update();
    try {
      logger.i('Loading subjects from api');
      final gradeId = _user?.grade.id;
      final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');

      _subjects = await SubjectsService().getSubjects(
        device.id,
        gradeId: gradeId ?? 0,
      );
      await HiveSubjectsStorage().write('subjects', _subjects);
    } catch (e) {
      logger.i('Loading subjects from storage');
      logger.e(e);
      _subjects = await HiveSubjectsStorage().read('subjects');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    update();

    try {
      final device = await UserDevice.getDeviceInfo(_user?.phoneNumber ?? '');

      _subjects = await SubjectsService().getSubjects(device.id, gradeId: 1);
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
          .where((n) => !n.isRead)
          .length;
      update();
    } catch (e) {
      // Notifications controller not found, ignore
    }
  }
}
