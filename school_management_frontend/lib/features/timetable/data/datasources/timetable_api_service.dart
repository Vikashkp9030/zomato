import '../../../../core/network/dio_client.dart';

class TimetableApiService {
  final DioClient dioClient;

  TimetableApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllTimetables({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      '/timetable',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTimetableById(String id) async {
    final response = await dioClient.get('/timetable/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getClassTimetable(String classId) async {
    final response = await dioClient.get('/classes/$classId/timetable');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTeacherTimetable(String teacherId) async {
    final response = await dioClient.get('/teachers/$teacherId/timetable');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createTimetable(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/timetable',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateTimetable(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/timetable/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteTimetable(String id) async {
    await dioClient.delete('/timetable/$id');
  }
}