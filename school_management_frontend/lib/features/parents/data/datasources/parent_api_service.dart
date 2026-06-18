import '../../../../core/network/dio_client.dart';

class ParentApiService {
  final DioClient dioClient;

  ParentApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllParents({
    int page = 1,
    int limit = 10,
    String? search,
    String? relationship,
  }) async {
    final response = await dioClient.get(
      '/parents',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (relationship != null) 'relationship': relationship,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getParentById(String id) async {
    final response = await dioClient.get('/parents/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createParent(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/parents',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateParent(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/parents/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteParent(String id) async {
    await dioClient.delete('/parents/$id');
  }

  Future<Map<String, dynamic>> getParentChildren(String parentId) async {
    final response = await dioClient.get('/parents/$parentId/children');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> linkParentToStudent(String parentId, String studentId) async {
    final response = await dioClient.post(
      '/parents/$parentId/link-student',
      data: {'studentId': studentId},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> unlinkParentFromStudent(String parentId, String studentId) async {
    final response = await dioClient.post(
      '/parents/$parentId/unlink-student',
      data: {'studentId': studentId},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getParentStudentProgress(String parentId, String studentId) async {
    final response = await dioClient.get('/parents/$parentId/student/$studentId/progress');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendMessageToParent(String parentId, Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/parents/$parentId/message',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }
}
