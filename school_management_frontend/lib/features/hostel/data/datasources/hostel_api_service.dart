import '../../../../core/network/dio_client.dart';

class HostelApiService {
  final DioClient dioClient;

  HostelApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllHostels({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      '/hostel',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getHostelById(String id) async {
    final response = await dioClient.get('/hostel/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStudentHostel(String studentId) async {
    final response = await dioClient.get('/students/$studentId/hostel');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> allocateRoom(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/hostel/allocate',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getHostelRooms(String hostelId) async {
    final response = await dioClient.get('/hostel/$hostelId/rooms');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateAllocation(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/hostel/allocate/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> removeAllocation(String id) async {
    await dioClient.delete('/hostel/allocate/$id');
  }
}