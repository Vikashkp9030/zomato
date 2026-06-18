import '../../../../core/network/dio_client.dart';

class FeesApiService {
  final DioClient dioClient;

  FeesApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllFees({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final response = await dioClient.get(
      '/fees',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFeeById(String id) async {
    final response = await dioClient.get('/fees/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStudentFees(String studentId) async {
    final response = await dioClient.get('/students/$studentId/fees');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFeeSummary(String studentId) async {
    final response = await dioClient.get('/students/$studentId/fees/summary');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createFee(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/fees',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> payFee(String feeId, Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/fees/$feeId/pay',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateReceipt(String feeId) async {
    final response = await dioClient.get('/fees/$feeId/receipt');
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteFee(String id) async {
    await dioClient.delete('/fees/$id');
  }
}