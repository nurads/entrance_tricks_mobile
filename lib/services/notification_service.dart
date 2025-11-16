import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vector_academy/models/models.dart';
import 'package:vector_academy/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

/// Local Notification Service for handling local notifications using awesome_notifications
class LocalNotificationService extends GetxService {
  static const String channelKey = 'study_plans_channel';
  static const String channelName = 'Study Plans';
  static const String channelDescription = 'Notifications for your study plans';

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  /// Initialize awesome notifications
  Future<void> _initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null, // Use default app icon
      [
        NotificationChannel(
          channelKey: channelKey,
          channelName: channelName,
          channelDescription: channelDescription,
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        ),
      ],
    );

    // Set up notification action listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onNotificationActionReceived,
      onNotificationCreatedMethod: _onNotificationCreated,
      onNotificationDisplayedMethod: _onNotificationDisplayed,
      onDismissActionReceivedMethod: _onNotificationDismissed,
    );
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      final isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
      
      if (!isAllowed) {
        logger.w('Notification permission denied');
        return false;
      }

      // Request SCHEDULE_EXACT_ALARM permission for Android 14+ (API 34+)
      // This is required for precise alarm scheduling (study plan reminders)
      if (Platform.isAndroid) {
        await _requestExactAlarmPermission();
      }

      logger.i('Notification permissions granted: $isAllowed');
      return isAllowed;
    } catch (e) {
      logger.e('Error requesting notification permissions: $e');
      return false;
    }
  }

  /// Request SCHEDULE_EXACT_ALARM permission for Android 14+
  /// This ensures precise scheduling of study plan reminders
  Future<void> _requestExactAlarmPermission() async {
    try {
      final status = await Permission.scheduleExactAlarm.status;
      
      if (status.isDenied) {
        // On Android 14+, this will open app settings where user can grant the permission
        final result = await Permission.scheduleExactAlarm.request();
        
        if (result.isGranted) {
          logger.i('Exact alarm permission granted');
        } else if (result.isDenied) {
          logger.w('Exact alarm permission denied');
          // Show user-friendly message
          Get.snackbar(
            'Permission Required',
            'For accurate study plan reminders, please enable "Alarms & reminders" permission in app settings.',
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (status.isGranted) {
        logger.i('Exact alarm permission already granted');
      }
    } catch (e) {
      logger.e('Error requesting exact alarm permission: $e');
    }
  }

  /// Check if notifications are allowed
  Future<bool> isNotificationAllowed() async {
    try {
      return await AwesomeNotifications().isNotificationAllowed();
    } catch (e) {
      logger.e('Error checking notification permission: $e');
      return false;
    }
  }

  /// Schedule a notification for a study plan
  Future<void> scheduleStudyPlanNotification(StudyPlan plan) async {
    try {
      // Cancel any existing notifications for this plan
      await cancelStudyPlanNotifications(plan.id);

      // If plan has no start date or end date, don't schedule
      if (plan.startDate == null && plan.endDate == null && plan.dueDate == null) {
        logger.d('Plan ${plan.id} has no date, skipping notification');
        return;
      }

      // Use startDate if available, otherwise use endDate or dueDate
      final notificationDate = plan.startDate ?? plan.endDate ?? plan.dueDate;
      if (notificationDate == null) return;

      // Don't schedule notifications for past dates
      if (notificationDate.isBefore(DateTime.now())) {
        logger.d('Plan ${plan.id} date is in the past, skipping notification');
        return;
      }

      // Schedule 15 minutes before the study plan time
      final notificationTime = notificationDate.subtract(const Duration(minutes: 15));

      if (plan.isRepeating && plan.repeatDays.isNotEmpty) {
        // Schedule repeating notifications
        await _scheduleRepeatingNotification(plan, notificationTime);
      } else {
        // Schedule one-time notification
        await _scheduleOneTimeNotification(plan, notificationTime);
      }

      logger.i('Scheduled notification for study plan: ${plan.id}');
    } catch (e) {
      logger.e('Error scheduling notification for plan ${plan.id}: $e');
    }
  }

  /// Schedule a one-time notification
  Future<void> _scheduleOneTimeNotification(
    StudyPlan plan,
    DateTime scheduledDate,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: plan.id,
        channelKey: channelKey,
        title: 'Study Plan Reminder',
        body: '${plan.title}${plan.subject.isNotEmpty ? ' - ${plan.subject}' : ''}',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
        fullScreenIntent: false,
        payload: {'plan_id': plan.id.toString()},
      ),
      schedule: NotificationCalendar.fromDate(
        date: scheduledDate,
        allowWhileIdle: true,
      ),
    );
  }

  /// Schedule repeating notifications based on repeatDays
  Future<void> _scheduleRepeatingNotification(
    StudyPlan plan,
    DateTime baseTime,
  ) async {
    // For each repeat day, schedule a notification
    for (final dayOfWeek in plan.repeatDays) {
      // Calculate the next occurrence of this day
      final nextDate = _getNextDateForDayOfWeek(dayOfWeek, baseTime);
      
      if (nextDate == null) continue;

      // Create a unique ID for each day (plan.id * 10 + dayOfWeek)
      final notificationId = plan.id * 10 + dayOfWeek;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: channelKey,
          title: 'Study Plan Reminder',
          body: '${plan.title}${plan.subject.isNotEmpty ? ' - ${plan.subject}' : ''}',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          fullScreenIntent: false,
          payload: {
            'plan_id': plan.id.toString(),
            'day_of_week': dayOfWeek.toString(),
          },
        ),
        schedule: NotificationCalendar(
          year: nextDate.year,
          month: nextDate.month,
          day: nextDate.day,
          hour: nextDate.hour,
          minute: nextDate.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          allowWhileIdle: true,
          // Repeat weekly
          weekday: dayOfWeek,
        ),
      );
    }
  }

  /// Get the next date for a specific day of week
  DateTime? _getNextDateForDayOfWeek(int dayOfWeek, DateTime baseTime) {
    final now = DateTime.now();
    final daysUntilNext = (dayOfWeek - now.weekday + 7) % 7;
    
    // If today is the target day and time hasn't passed, use today
    if (daysUntilNext == 0 && baseTime.hour * 60 + baseTime.minute > now.hour * 60 + now.minute) {
      return DateTime(
        now.year,
        now.month,
        now.day,
        baseTime.hour,
        baseTime.minute,
      );
    }

    // Otherwise, get the next occurrence
    final nextDate = now.add(Duration(days: daysUntilNext == 0 ? 7 : daysUntilNext));
    return DateTime(
      nextDate.year,
      nextDate.month,
      nextDate.day,
      baseTime.hour,
      baseTime.minute,
    );
  }

  /// Cancel all notifications for a study plan
  Future<void> cancelStudyPlanNotifications(int planId) async {
    try {
      // Cancel the main notification
      await AwesomeNotifications().cancel(planId);

      // Cancel repeating notifications (plan.id * 10 + dayOfWeek)
      for (int day = 1; day <= 7; day++) {
        final notificationId = planId * 10 + day;
        await AwesomeNotifications().cancel(notificationId);
      }

      logger.d('Cancelled notifications for plan: $planId');
    } catch (e) {
      logger.e('Error cancelling notifications for plan $planId: $e');
    }
  }

  /// Schedule notifications for all study plans
  Future<void> scheduleAllStudyPlans(List<StudyPlan> plans) async {
    final isAllowed = await isNotificationAllowed();
    if (!isAllowed) {
      logger.w('Notifications not allowed, skipping scheduling');
      return;
    }

    for (final plan in plans) {
      await scheduleStudyPlanNotification(plan);
    }

    logger.i('Scheduled notifications for ${plans.length} study plans');
  }

  /// Cancel all study plan notifications
  Future<void> cancelAllStudyPlanNotifications() async {
    try {
      await AwesomeNotifications().cancelAll();
      logger.i('Cancelled all study plan notifications');
    } catch (e) {
      logger.e('Error cancelling all notifications: $e');
    }
  }

  // Notification action handlers
  static Future<void> _onNotificationActionReceived(
    ReceivedAction receivedAction,
  ) async {
    logger.d('Notification action received: ${receivedAction.id}');
    // Handle notification tap actions here if needed
  }

  static Future<void> _onNotificationCreated(
    ReceivedNotification receivedNotification,
  ) async {
    logger.d('Notification created: ${receivedNotification.id}');
  }

  static Future<void> _onNotificationDisplayed(
    ReceivedNotification receivedNotification,
  ) async {
    logger.d('Notification displayed: ${receivedNotification.id}');
  }

  static Future<void> _onNotificationDismissed(
    ReceivedAction receivedAction,
  ) async {
    logger.d('Notification dismissed: ${receivedAction.id}');
  }
}

