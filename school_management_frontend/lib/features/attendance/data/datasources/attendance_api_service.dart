import '../../../../core/network/dio_client.dart';

class AttendanceApiService {
  final DioClient dioClient;

  AttendanceApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllAttendance({
    int page = 1,
    int limit = 10,
    String? classId,
    String? studentId,
    String? date,
  }) async {
    final response = await dioClient.get(
      '/attendance',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (classId != null) 'classId': classId,
        if (studentId != null) 'studentId': studentId,
        if (date != null) 'date': date,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAttendanceById(String id) async {
    final response = await dioClient.get('/attendance/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> markAttendance(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/attendance',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateAttendance(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/attendance/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteAttendance(String id) async {
    await dioClient.delete('/attendance/$id');
  }

  Future<Map<String, dynamic>> getStudentAttendance(String studentId) async {
    final response = await dioClient.get('/attendance/student/$studentId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getClassAttendance(String classId, {String? date}) async {
    final response = await dioClient.get(
      '/attendance/class/$classId',
      queryParameters: {
        if (date != null) 'date': date,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAttendanceSummary(String studentId) async {
    final response = await dioClient.get('/attendance/student/$studentId/summary');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> markBulkAttendance(List<Map<String, dynamic>> data) async {
    final response = await dioClient.post(
      '/attendance/bulk',
      data: {'records': data},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateAttendanceReport(String classId, String month) async {
    final response = await dioClient.get(
      '/attendance/report',
      queryParameters: {
        'classId': classId,
        'month': month,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
