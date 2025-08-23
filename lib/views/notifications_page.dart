import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/notifications_controller.dart';
import 'package:entrance_tricks/components/components.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationsController());
    return GetBuilder<NotificationsController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            if (controller.hasUnreadNotifications)
              TextButton(
                onPressed: () => controller.markAllAsRead(),
                child: Text('Mark all read'),
              ),
          ],
        ),
        body: controller.isLoading
            ? _buildLoadingState()
            : controller.notifications.isEmpty
                ? _buildEmptyState(context)
                : _buildNotificationsList(context, controller),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: EdgeInsets.all(20),
      itemCount: 8,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) => LoadingListTile(hasSubtitle: true),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 16),
          Text(
            'No notifications',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context, NotificationsController controller) {
    return ListView.separated(
      padding: EdgeInsets.all(20),
      itemCount: controller.notifications.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = controller.notifications[index];
        return _buildNotificationItem(context, notification, controller);
      },
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    Map<String, dynamic> notification,
    NotificationsController controller,
  ) {
    IconData getIcon() {
      switch (notification['type']) {
        case 'exam':
          return Icons.quiz;
        case 'news':
          return Icons.article;
        case 'achievement':
          return Icons.emoji_events;
        case 'reminder':
          return Icons.schedule;
        case 'update':
          return Icons.system_update;
        default:
          return Icons.notifications;
      }
    }

    Color getIconColor() {
      switch (notification['type']) {
        case 'exam':
          return Theme.of(context).colorScheme.primary;
        case 'news':
          return const Color(0xFF3B82F6);
        case 'achievement':
          return const Color(0xFFF59E0B);
        case 'reminder':
          return Theme.of(context).colorScheme.secondary;
        case 'update':
          return const Color(0xFF8B5CF6);
        default:
          return Theme.of(context).colorScheme.onSurfaceVariant;
      }
    }

    return CustomCard(
      backgroundColor: notification['isRead'] 
          ? null 
          : Theme.of(context).colorScheme.primary.withOpacity(0.03),
      onTap: () => controller.openNotification(notification),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: getIconColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              getIcon(),
              color: getIconColor(),
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification['title'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: notification['isRead'] 
                              ? FontWeight.w500 
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (!notification['isRead'])
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      notification['time'],
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 8),
                    StatusBadge(
                      text: notification['type'].toUpperCase(),
                      status: BadgeStatus.neutral,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
