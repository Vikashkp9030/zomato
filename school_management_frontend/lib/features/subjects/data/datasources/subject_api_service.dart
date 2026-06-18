import '../../../../core/network/dio_client.dart';

class SubjectApiService {
  final DioClient dioClient;

  SubjectApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllSubjects({
    int page = 1,
    int limit = 10,
    String? search,
    String? category,
  }) async {
    final response = await dioClient.get(
      '/subjects',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (category != null) 'category': category,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSubjectById(String id) async {
    final response = await dioClient.get('/subjects/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createSubject(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/subjects',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateSubject(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/subjects/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteSubject(String id) async {
    await dioClient.delete('/subjects/$id');
  }

  Future<Map<String, dynamic>> getSubjectTeachers(String subjectId) async {
    final response = await dioClient.get('/subjects/$subjectId/teachers');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSubjectClasses(String subjectId) async {
    final response = await dioClient.get('/subjects/$subjectId/classes');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> assignSubjectToClass(String subjectId, String classId) async {
    final response = await dioClient.post(
      '/subjects/$subjectId/assign-class',
      data: {'classId': classId},
    );
    return response.data as Map<String, dynamic>;
  }
}
