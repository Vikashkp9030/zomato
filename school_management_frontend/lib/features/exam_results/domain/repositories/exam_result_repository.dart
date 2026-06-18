import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exam_result_entity.dart';

abstract class ExamResultRepository {
  Future<Either<Failure, List<dynamic>>> getAllResults({int page = 1, int limit = 10});
  Future<Either<Failure, ExamResultEntity>> getResultById(int id);
  Future<Either<Failure, ExamResultEntity>> createResult(Map<String, dynamic> data);
  Future<Either<Failure, ExamResultEntity>> updateResult(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteResult(int id);
  Future<Either<Failure, dynamic>> getStudentResults(int studentId);
  Future<Either<Failure, dynamic>> getClassResults(int classId);
  Future<Either<Failure, dynamic>> getExamStatistics(int examId);
}
