import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/home_dashboard_controller.dart';

class NotificationsController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  bool get hasUnreadNotifications =>
      _notifications.any((notification) => !notification['isRead']);

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

      _notifications = [
        {
          'id': 1,
          'type': 'exam',
          'title': 'New Mock Test Available',
          'message':
              'Physics Mock Test 3 is now available. Take the test to assess your preparation level.',
          'time': '2 hours ago',
          'isRead': false,
        },
        {
          'id': 2,
          'type': 'achievement',
          'title': 'Congratulations!',
          'message':
              'You have completed your 15-day study streak. Keep up the excellent work!',
          'time': '1 day ago',
          'isRead': false,
        },
        {
          'id': 3,
          'type': 'news',
          'title': 'New Study Material Added',
          'message':
              'Quantum Mechanics chapter has been added to Physics course with comprehensive notes and videos.',
          'time': '2 days ago',
          'isRead': false,
        },
        {
          'id': 4,
          'type': 'reminder',
          'title': 'Study Reminder',
          'message':
              'Don\'t forget to complete today\'s Chemistry practice questions.',
          'time': '3 days ago',
          'isRead': true,
        },
        {
          'id': 5,
          'type': 'exam',
          'title': 'Test Results Available',
          'message':
              'Your Chemistry Quiz results are now available. You scored 85%!',
          'time': '5 days ago',
          'isRead': true,
        },
        {
          'id': 6,
          'type': 'update',
          'title': 'App Update Available',
          'message':
              'Version 2.1.0 is available with dark mode and improved video player.',
          'time': '1 week ago',
          'isRead': true,
        },
        {
          'id': 7,
          'type': 'news',
          'title': 'Scholarship Program',
          'message':
              'Applications for 2024 scholarship program are now open. Apply before the deadline.',
          'time': '1 week ago',
          'isRead': true,
        },
        {
          'id': 8,
          'type': 'achievement',
          'title': 'First Quiz Completed',
          'message':
              'Congratulations on completing your first quiz! You\'re on the right track.',
          'time': '2 weeks ago',
          'isRead': true,
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void openNotification(Map<String, dynamic> notification) {
    // Mark as read if not already read
    if (!notification['isRead']) {
      notification['isRead'] = true;
      update();

      // Update notification count in home dashboard
      try {
        final homeDashboardController = Get.find<HomeDashboardController>();
        homeDashboardController.updateNotificationCount();
      } catch (e) {
        // Controller not found, ignore
      }
    }

    // Handle different notification types
    switch (notification['type']) {
      case 'exam':
        Get.snackbar('Info', 'Opening exam: ${notification['title']}');
        break;
      case 'news':
        Get.snackbar('Info', 'Opening news: ${notification['title']}');
        break;
      case 'achievement':
        _showAchievementDialog(notification);
        break;
      case 'reminder':
        Get.snackbar('Info', 'Opening reminder: ${notification['title']}');
        break;
      case 'update':
        Get.snackbar('Info', 'Opening app update information');
        break;
      default:
        Get.snackbar('Info', 'Opening: ${notification['title']}');
    }
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
    update();

    // Update notification count in home dashboard
    try {
      final homeDashboardController = Get.find<HomeDashboardController>();
      homeDashboardController.updateNotificationCount();
    } catch (e) {
      // Controller not found, ignore
    }

    Get.snackbar(
      'Success',
      'All notifications marked as read',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showAchievementDialog(Map<String, dynamic> notification) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: Color(0xFFF59E0B), size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                notification['title'],
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Text(notification['message']),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Awesome!')),
        ],
      ),
    );
  }
}
