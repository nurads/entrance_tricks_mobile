import 'package:entrance_tricks/services/api/api.dart';
import 'package:entrance_tricks/models/models.dart';
import "package:entrance_tricks/utils/utils.dart";

class NotificationService {
  final ApiClient apiClient = ApiClient();

  Future<List<Notification>> getNotifications() async {
    final response = await apiClient.get(
      '/app/notifications',
      authenticated: true,
    );
    logger.d(response.data);
    return (response.data as List)
        .map((e) => Notification.fromJson(e))
        .toList();
  }

  Future<void> markAsRead(int id) async {
    await apiClient.post(
      '/app/notifications/$id/mark-as-read',
      authenticated: true,
    );
  }
}
