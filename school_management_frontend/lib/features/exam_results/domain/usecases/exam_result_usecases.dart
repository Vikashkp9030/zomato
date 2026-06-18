import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exam_result_entity.dart';
import '../repositories/exam_result_repository.dart';

class ExamResultUseCases {
  final ExamResultRepository repository;

  ExamResultUseCases(this.repository);

  Future<Either<Failure, List<dynamic>>> getAllResults({int page = 1, int limit = 10}) {
    return repository.getAllResults(page: page, limit: limit);
  }

  Future<Either<Failure, ExamResultEntity>> getResultById(int id) {
    return repository.getResultById(id);
  }

  Future<Either<Failure, ExamResultEntity>> createResult(Map<String, dynamic> data) {
    return repository.createResult(data);
  }

  Future<Either<Failure, ExamResultEntity>> updateResult(int id, Map<String, dynamic> data) {
    return repository.updateResult(id, data);
  }

  Future<Either<Failure, void>> deleteResult(int id) {
    return repository.deleteResult(id);
  }
  Future<Either<Failure, dynamic>> getStudentResults(int studentId) {
    return repository.getStudentResults(studentId);
  }

  Future<Either<Failure, dynamic>> getClassResults(int classId) {
    return repository.getClassResults(classId);
  }

  Future<Either<Failure, dynamic>> getExamStatistics(int examId) {
    return repository.getExamStatistics(examId);
  }

}
