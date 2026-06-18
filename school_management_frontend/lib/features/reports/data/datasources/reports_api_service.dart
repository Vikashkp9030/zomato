import '../../../../core/network/dio_client.dart';

class ReportsApiService {
  final DioClient dioClient;

  ReportsApiService(this.dioClient);

  Future<Map<String, dynamic>> generateAcademicReport({
    required String classId,
    String? month,
  }) async {
    final response = await dioClient.get(
      '/reports/academic',
      queryParameters: {
        'class_id': classId,
        if (month != null) 'month': month,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateAttendanceReport({
    required String classId,
    required String month,
  }) async {
    final response = await dioClient.get(
      '/reports/attendance',
      queryParameters: {
        'class_id': classId,
        'month': month,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateFeesReport({
    String? month,
    String? classId,
  }) async {
    final response = await dioClient.get(
      '/reports/fees',
      queryParameters: {
        if (month != null) 'month': month,
        if (classId != null) 'class_id': classId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateStudentProgressReport(String studentId) async {
    final response = await dioClient.get('/reports/student/$studentId/progress');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateClassAnalyticsReport(String classId) async {
    final response = await dioClient.get('/reports/class/$classId/analytics');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAllReports({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      '/reports',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getReportById(String id) async {
    final response = await dioClient.get('/reports/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<void> downloadReport(String id) async {
    await dioClient.get('/reports/$id/download');
  }
}