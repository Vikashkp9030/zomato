import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/exam_result_entity.dart';
import '../../domain/entities/exam_stats_entity.dart';
import '../../domain/repositories/exam_result_repository.dart';
import '../datasources/exam_result_api_service.dart';

class ExamResultRepositoryImpl implements ExamResultRepository {
  final ExamResultApiService examResultApiService;
  final Logger _logger = Logger();

  ExamResultRepositoryImpl(this.examResultApiService);

  @override
  Future<Either<Failure, List<dynamic>>> getAllResults({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await examResultApiService.getAllResults(page: page, limit: limit);
      final data = response['data'] as List;
      final results = data
          .map((r) => ExamResultEntity(
                id: r['id'],
                examId: r['exam_id'],
                studentId: r['student_id'],
                marksObtained: (r['marks_obtained'] as num).toDouble(),
                grade: r['grade'],
                status: r['status'],
                attempt: r['attempt'],
              ))
          .toList();
      _logger.i('Fetched ${results.length} results');
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 0));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch results'));
    }
  }

  @override
  Future<Either<Failure, ExamResultEntity>> getResultById(int id) async {
    try {
      final response = await examResultApiService.getResultById(id.toString());
      final data = response['data'];
      return Right(ExamResultEntity(
        id: data['id'],
        examId: data['exam_id'],
        studentId: data['student_id'],
        marksObtained: (data['marks_obtained'] as num).toDouble(),
        grade: data['grade'],
        status: data['status'],
        attempt: data['attempt'],
      ));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch result details'));
    }
  }

  @override
  Future<Either<Failure, ExamResultEntity>> createResult(Map<String, dynamic> data) async {
    try {
      final response = await examResultApiService.createResult(data);
      final resultData = response['data'];
      _logger.i('Result created for student: ${resultData['student_id']}');
      return Right(ExamResultEntity(
        id: resultData['id'],
        examId: resultData['exam_id'],
        studentId: resultData['student_id'],
        marksObtained: (resultData['marks_obtained'] as num).toDouble(),
        grade: resultData['grade'],
        status: resultData['status'],
        attempt: resultData['attempt'],
      ));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to create result'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error creating result'));
    }
  }

  @override
  Future<Either<Failure, ExamResultEntity>> updateResult(int id, Map<String, dynamic> data) async {
    try {
      final response = await examResultApiService.updateResult(id.toString(), data);
      final resultData = response['data'];
      _logger.i('Result updated: $id');
      return Right(ExamResultEntity(
        id: resultData['id'],
        examId: resultData['exam_id'],
        studentId: resultData['student_id'],
        marksObtained: (resultData['marks_obtained'] as num).toDouble(),
        grade: resultData['grade'],
        status: resultData['status'],
        attempt: resultData['attempt'],
      ));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to update result'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error updating result'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteResult(int id) async {
    try {
      await examResultApiService.deleteResult(id.toString());
      _logger.i('Result deleted: $id');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to delete result'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error deleting result'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getStudentResults(int studentId) async {
    try {
      final response = await examResultApiService.getStudentResults(studentId.toString());
      final data = response['data'] as List;
      final results = data
          .map((r) => ExamResultEntity(
                id: r['id'],
                examId: r['exam_id'],
                studentId: r['student_id'],
                marksObtained: (r['marks_obtained'] as num).toDouble(),
                grade: r['grade'],
                status: r['status'],
                attempt: r['attempt'],
              ))
          .toList();
      return Right(results);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch student results'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getClassResults(int classId) async {
    try {
      final response = await examResultApiService.getClassResults(classId.toString());
      final data = response['data'] as List;
      final results = data
          .map((r) => ExamResultEntity(
                id: r['id'],
                examId: r['exam_id'],
                studentId: r['student_id'],
                marksObtained: (r['marks_obtained'] as num).toDouble(),
                grade: r['grade'],
                status: r['status'],
                attempt: r['attempt'],
              ))
          .toList();
      return Right(results);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch class results'));
    }
  }

  @override
  Future<Either<Failure, ExamStatsEntity>> getExamStatistics(int examId) async {
    try {
      final response = await examResultApiService.getResultStatistics(examId.toString());
      final stats = response['data'];
      return Right(ExamStatsEntity(
        examId: stats['exam_id'],
        totalStudents: stats['total_students'],
        passedStudents: stats['passed_students'],
        failedStudents: stats['failed_students'],
        averageMarks: (stats['average_marks'] as num).toDouble(),
        highestMarks: (stats['highest_marks'] as num).toDouble(),
        lowestMarks: (stats['lowest_marks'] as num).toDouble(),
      ));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch exam statistics'));
    }
  }
}
