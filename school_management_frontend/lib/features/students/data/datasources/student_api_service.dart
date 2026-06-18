import '../../../../core/network/dio_client.dart';

class StudentApiService {
  final DioClient dioClient;

  StudentApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllStudents({
    int page = 1,
    int limit = 10,
    String? search,
    String? classId,
    String? status,
  }) async {
    final response = await dioClient.get(
      '/students',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (classId != null) 'classId': classId,
        if (status != null) 'status': status,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStudentById(String id) async {
    final response = await dioClient.get('/students/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createStudent(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/students',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateStudent(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/students/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteStudent(String id) async {
    await dioClient.delete('/students/$id');
  }

  Future<Map<String, dynamic>> getStudentPerformance(String studentId) async {
    final response = await dioClient.get('/students/$studentId/performance');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStudentResults(String studentId) async {
    final response = await dioClient.get('/students/$studentId/results');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStudentAttendance(String studentId) async {
    final response = await dioClient.get('/students/$studentId/attendance');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> promoteStudent(String studentId) async {
    final response = await dioClient.post(
      '/students/$studentId/promote',
    );
    return response.data as Map<String, dynamic>;
  }
}
