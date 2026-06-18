import '../../../../core/network/dio_client.dart';

class NotificationsApiService {
  final DioClient dioClient;

  NotificationsApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllNotifications({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
  }) async {
    final response = await dioClient.get(
      '/notifications',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (unreadOnly != null) 'unread_only': unreadOnly,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getNotificationById(String id) async {
    final response = await dioClient.get('/notifications/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> markAsRead(String id) async {
    final response = await dioClient.post(
      '/notifications/$id/read',
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> markAllAsRead() async {
    final response = await dioClient.post(
      '/notifications/read-all',
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getNotificationStats() async {
    final response = await dioClient.get('/notifications/stats');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getNotificationsByCategory(String category) async {
    final response = await dioClient.get(
      '/notifications/category/$category',
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteNotification(String id) async {
    await dioClient.delete('/notifications/$id');
  }

  Future<void> deleteAllNotifications() async {
    await dioClient.delete('/notifications');
  }
}