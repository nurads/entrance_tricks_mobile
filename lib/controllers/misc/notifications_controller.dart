import 'package:get/get.dart';

class NotificationsController extends GetxController {
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    update();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Mock notifications data
      _notifications = [
        {
          'id': 1,
          'title': 'New Chapter Available',
          'message': 'Chapter 2 of Physics is now available for study',
          'time': '2 hours ago',
          'isRead': false,
          'type': 'chapter',
        },
        {
          'id': 2,
          'title': 'Quiz Reminder',
          'message': 'Don\'t forget to complete your daily quiz',
          'time': '5 hours ago',
          'isRead': false,
          'type': 'quiz',
        },
        {
          'id': 3,
          'title': 'Study Streak',
          'message': 'Congratulations! You\'ve maintained a 7-day study streak',
          'time': '1 day ago',
          'isRead': true,
          'type': 'achievement',
        },
        {
          'id': 4,
          'title': 'System Update',
          'message': 'New features have been added to the app',
          'time': '2 days ago',
          'isRead': true,
          'type': 'system',
        },
      ];

      _unreadCount = _notifications.where((n) => !n['isRead']).length;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void markAsRead(int notificationId) {
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
      _unreadCount = _notifications.where((n) => !n['isRead']).length;
      update();
    }
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
    _unreadCount = 0;
    update();
  }

  void deleteNotification(int notificationId) {
    _notifications.removeWhere((n) => n['id'] == notificationId);
    _unreadCount = _notifications.where((n) => !n['isRead']).length;
    update();
  }

  void clearAllNotifications() {
    _notifications.clear();
    _unreadCount = 0;
    update();
  }
}
