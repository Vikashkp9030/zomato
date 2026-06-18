import '../../../../core/network/dio_client.dart';

class ClassApiService {
  final DioClient dioClient;

  ClassApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllClasses({
    int page = 1,
    int limit = 10,
    String? search,
    String? grade,
  }) async {
    final response = await dioClient.get(
      '/classes',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (grade != null) 'grade': grade,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getClassById(String id) async {
    final response = await dioClient.get('/classes/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createClass(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/classes',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateClass(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/classes/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteClass(String id) async {
    await dioClient.delete('/classes/$id');
  }

  Future<Map<String, dynamic>> getClassStudents(String classId) async {
    final response = await dioClient.get('/classes/$classId/students');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getClassSubjects(String classId) async {
    final response = await dioClient.get('/classes/$classId/subjects');
    return response.data as Map<String, dynamic>;
  }
}
