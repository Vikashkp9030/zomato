import '../../../../core/network/dio_client.dart';

class ExamApiService {
  final DioClient dioClient;

  ExamApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllExams({
    int page = 1,
    int limit = 10,
    String? search,
    String? classId,
    String? subjectId,
    String? status,
  }) async {
    final response = await dioClient.get(
      '/exams',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (classId != null) 'classId': classId,
        if (subjectId != null) 'subjectId': subjectId,
        if (status != null) 'status': status,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getExamById(String id) async {
    final response = await dioClient.get('/exams/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createExam(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/exams',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateExam(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      '/exams/$id',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteExam(String id) async {
    await dioClient.delete('/exams/$id');
  }

  Future<Map<String, dynamic>> getExamSchedule({
    String? classId,
    String? startDate,
    String? endDate,
  }) async {
    final response = await dioClient.get(
      '/exams/schedule',
      queryParameters: {
        if (classId != null) 'classId': classId,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getExamResults(String examId) async {
    final response = await dioClient.get('/exams/$examId/results');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> publishExam(String examId) async {
    final response = await dioClient.post(
      '/exams/$examId/publish',
    );
    return response.data as Map<String, dynamic>;
  }
}
