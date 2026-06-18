import '../../../../core/network/dio_client.dart';

class ExamResultApiService {
  final DioClient dioClient;

  ExamResultApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllResults({
    int page = 1,
    int limit = 10,
    String? examId,
    String? studentId,
    String? classId,
  }) async {
    final response = await dioClient.get(
      '/results',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (examId != null) 'examId': examId,
        if (studentId != null) 'studentId': studentId,
        if (classId != null) 'classId': classId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getResultById(String id) async {
    final response = await dioClient.get('/results/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createResult(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/results',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateResult(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/results/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteResult(String id) async {
    await dioClient.delete('/results/$id');
  }

  Future<Map<String, dynamic>> getStudentResults(String studentId) async {
    final response = await dioClient.get('/results/student/$studentId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getClassResults(String classId) async {
    final response = await dioClient.get('/results/class/$classId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> calculateGPA(String studentId) async {
    final response = await dioClient.get('/results/student/$studentId/gpa');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getResultStatistics(String examId) async {
    final response = await dioClient.get('/results/exam/$examId/statistics');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTopPerformers(String classId) async {
    final response = await dioClient.get('/results/class/$classId/top-performers');
    return response.data as Map<String, dynamic>;
  }
}
