import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/exam_entity.dart';
import '../repositories/exam_repository.dart';

class ExamUseCases {
  final ExamRepository repository;

  ExamUseCases(this.repository);

  Future<Either<Failure, List<ExamEntity>>> getAllExams({int page = 1, int limit = 10}) {
    return repository.getAllExams(page: page, limit: limit);
  }

  Future<Either<Failure, ExamEntity>> getExamById(int id) {
    return repository.getExamById(id);
  }

  Future<Either<Failure, ExamEntity>> createExam(Map<String, dynamic> data) {
    return repository.createExam(data);
  }

  Future<Either<Failure, ExamEntity>> updateExam(int id, Map<String, dynamic> data) {
    return repository.updateExam(id, data);
  }

  Future<Either<Failure, void>> deleteExam(int id) {
    return repository.deleteExam(id);
  }

  Future<Either<Failure, List<ExamEntity>>> getUpcomingExams() {
    return repository.getUpcomingExams();
  }

  Future<Either<Failure, List<ExamEntity>>> getExamsByClass(int classId) {
    return repository.getExamsByClass(classId);
  }

  Future<Either<Failure, dynamic>> getExamResults(int examId) {
    return repository.getExamResults(examId);
  }
}
