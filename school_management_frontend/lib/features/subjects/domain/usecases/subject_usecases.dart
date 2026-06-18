import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/subject_entity.dart';
import '../repositories/subject_repository.dart';

class SubjectUseCases {
  final SubjectRepository repository;

  SubjectUseCases(this.repository);

  Future<Either<Failure, List<SubjectEntity>>> getAllSubjects({int page = 1, int limit = 10}) {
    return repository.getAllSubjects(page: page, limit: limit);
  }

  Future<Either<Failure, SubjectEntity>> getSubjectById(int id) {
    return repository.getSubjectById(id);
  }

  Future<Either<Failure, SubjectEntity>> createSubject(Map<String, dynamic> data) {
    return repository.createSubject(data);
  }

  Future<Either<Failure, SubjectEntity>> updateSubject(int id, Map<String, dynamic> data) {
    return repository.updateSubject(id, data);
  }

  Future<Either<Failure, void>> deleteSubject(int id) {
    return repository.deleteSubject(id);
  }

  Future<Either<Failure, dynamic>> getSubjectTeachers(int subjectId) {
    return repository.getSubjectTeachers(subjectId);
  }

  Future<Either<Failure, dynamic>> getSubjectClasses(int subjectId) {
    return repository.getSubjectClasses(subjectId);
  }
}
