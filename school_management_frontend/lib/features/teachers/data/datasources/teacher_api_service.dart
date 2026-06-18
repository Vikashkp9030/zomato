import '../../../../core/network/dio_client.dart';

class TeacherApiService {
  final DioClient dioClient;

  TeacherApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllTeachers({
    int page = 1,
    int limit = 10,
    String? search,
    String? specialization,
    String? department,
  }) async {
    final response = await dioClient.get(
      '/teachers',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (specialization != null) 'specialization': specialization,
        if (department != null) 'department': department,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTeacherById(String id) async {
    final response = await dioClient.get('/teachers/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createTeacher(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/teachers',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateTeacher(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/teachers/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteTeacher(String id) async {
    await dioClient.delete('/teachers/$id');
  }

  Future<Map<String, dynamic>> getTeacherClasses(String teacherId) async {
    final response = await dioClient.get('/teachers/$teacherId/classes');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTeacherSubjects(String teacherId) async {
    final response = await dioClient.get('/teachers/$teacherId/subjects');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> assignTeacherToClass(String teacherId, String classId) async {
    final response = await dioClient.post(
      '/teachers/$teacherId/assign-class',
      data: {'classId': classId},
    );
    return response.data as Map<String, dynamic>;
  }
}
