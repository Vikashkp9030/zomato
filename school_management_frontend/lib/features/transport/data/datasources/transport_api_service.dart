import '../../../../core/network/dio_client.dart';

class TransportApiService {
  final DioClient dioClient;

  TransportApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllTransport({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      '/transport',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTransportById(String id) async {
    final response = await dioClient.get('/transport/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getRoutes() async {
    final response = await dioClient.get('/transport/routes');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStudentTransport(String studentId) async {
    final response = await dioClient.get('/students/$studentId/transport');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> assignTransport(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/transport',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateTransport(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/transport/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> removeTransport(String id) async {
    await dioClient.delete('/transport/$id');
  }
}