import '../../../../core/network/dio_client.dart';

class DashboardApiService {
  final DioClient dioClient;

  DashboardApiService(this.dioClient);

  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await dioClient.get('/dashboard/stats');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getWeeklyAttendance() async {
    final response = await dioClient.get('/dashboard/attendance/weekly');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getClassPerformance() async {
    final response = await dioClient.get('/dashboard/performance');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUpcomingExams() async {
    final response = await dioClient.get('/dashboard/exams/upcoming');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPendingFees() async {
    final response = await dioClient.get('/dashboard/fees/pending');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getNotifications({int limit = 10}) async {
    final response = await dioClient.get(
      '/dashboard/notifications',
      queryParameters: {'limit': limit},
    );
    return response.data as Map<String, dynamic>;
  }
}