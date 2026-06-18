import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exam_entity.dart';

abstract class ExamRepository {
  Future<Either<Failure, List<ExamEntity>>> getAllExams({int page = 1, int limit = 10});
  Future<Either<Failure, ExamEntity>> getExamById(int id);
  Future<Either<Failure, ExamEntity>> createExam(Map<String, dynamic> data);
  Future<Either<Failure, ExamEntity>> updateExam(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteExam(int id);
  Future<Either<Failure, List<ExamEntity>>> getUpcomingExams();
  Future<Either<Failure, List<ExamEntity>>> getExamsByClass(int classId);
  Future<Either<Failure, dynamic>> getExamResults(int examId);
}
