import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/repositories/exam_repository.dart';
import '../datasources/exam_api_service.dart';
import '../models/exam_model.dart';
import '../../../exam_results/domain/entities/exam_result_entity.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamApiService examApiService;
  final Logger _logger = Logger();

  ExamRepositoryImpl(this.examApiService);

  @override
  Future<Either<Failure, List<ExamEntity>>> getAllExams({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await examApiService.getAllExams(page: page, limit: limit);
      final data = response['data'] as List;
      final exams = data.map((e) => _mapExamModelToEntity(ExamModel.fromJson(e))).toList();
      _logger.i('Fetched ${exams.length} exams');
      return Right(exams);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 0));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch exams'));
    }
  }

  @override
  Future<Either<Failure, ExamEntity>> getExamById(int id) async {
    try {
      final response = await examApiService.getExamById(id.toString());
      final examModel = ExamModel.fromJson(response['data']);
      return Right(_mapExamModelToEntity(examModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch exam details'));
    }
  }

  @override
  Future<Either<Failure, ExamEntity>> createExam(Map<String, dynamic> data) async {
    try {
      final response = await examApiService.createExam(data);
      final examModel = ExamModel.fromJson(response['data']);
      _logger.i('Exam created: ${examModel.examName}');
      return Right(_mapExamModelToEntity(examModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to create exam'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error creating exam'));
    }
  }

  @override
  Future<Either<Failure, ExamEntity>> updateExam(int id, Map<String, dynamic> data) async {
    try {
      final response = await examApiService.updateExam(id.toString(), data);
      final examModel = ExamModel.fromJson(response['data']);
      _logger.i('Exam updated: ${examModel.examName}');
      return Right(_mapExamModelToEntity(examModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to update exam'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error updating exam'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExam(int id) async {
    try {
      await examApiService.deleteExam(id.toString());
      _logger.i('Exam deleted: $id');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to delete exam'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error deleting exam'));
    }
  }

  @override
  Future<Either<Failure, List<ExamEntity>>> getUpcomingExams() async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await examApiService.getExamSchedule(startDate: now);
      final data = response['data'] as List;
      final exams = data.map((e) => _mapExamModelToEntity(ExamModel.fromJson(e))).toList();
      return Right(exams);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch upcoming exams'));
    }
  }

  @override
  Future<Either<Failure, List<ExamEntity>>> getExamsByClass(int classId) async {
    try {
      final response = await examApiService.getAllExams(classId: classId.toString());
      final data = response['data'] as List;
      final exams = data.map((e) => _mapExamModelToEntity(ExamModel.fromJson(e))).toList();
      return Right(exams);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch class exams'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getExamResults(int examId) async {
    try {
      final response = await examApiService.getExamResults(examId.toString());
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
      return Left(NetworkFailure(message: 'Failed to fetch exam results'));
    }
  }

  ExamEntity _mapExamModelToEntity(ExamModel model) {
    return ExamEntity(
      id: model.id,
      examName: model.examName,
      examType: model.examType,
      examDate: model.examDate,
      examTime: model.examTime,
      totalMarks: model.totalMarks,
      passingMarks: model.passingMarks,
      subjectId: model.subjectId,
      classId: model.classId,
    );
  }
}
