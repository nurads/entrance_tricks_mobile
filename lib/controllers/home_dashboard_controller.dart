import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/controllers/main_navigation_controller.dart';
import 'package:entrance_tricks/controllers/notifications_controller.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/subjects.dart';
import 'package:entrance_tricks/utils/utils.dart';

class HomeDashboardController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _userName = 'Student';
  String get userName => _userName;

  int _notificationCount = 3;
  int get notificationCount => _notificationCount;

  int _studyStreak = 7;
  int get studyStreak => _studyStreak;

  int _completedExams = 12;
  int get completedExams => _completedExams;

  List<Map<String, dynamic>> _recentExams = [];
  List<Map<String, dynamic>> get recentExams => _recentExams;

  List<Map<String, dynamic>> _recentNews = [];
  List<Map<String, dynamic>> get recentNews => _recentNews;

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  // List<Map<String, dynamic>> _grades = [];
  // List<Map<String, dynamic>> get grades => _grades;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    update();

    try {
      // Simulate API calls
      // await Future.delayed(Duration(seconds: 1));

      _userName = 'John Doe';
      _studyStreak = 15;
      _completedExams = 8;
      _notificationCount = 5;

      _recentExams = [
        {
          'id': 1,
          'title': 'Physics Mock Test 2',
          'questions': 30,
          'duration': 60,
          'status': 'Available',
          'score': null,
        },
        {
          'id': 2,
          'title': 'Chemistry Quiz 1',
          'questions': 15,
          'duration': 30,
          'status': 'Completed',
          'score': 85,
        },
        {
          'id': 3,
          'title': 'Mathematics Practice',
          'questions': 25,
          'duration': 45,
          'status': 'In Progress',
          'score': null,
        },
      ];

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

      _subjects = await SubjectsService().getSubjects();
      logger.i(_subjects.map((e) => e.icon).toList());
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

  void showSearch() {
    Get.to(() => SearchPage());
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
