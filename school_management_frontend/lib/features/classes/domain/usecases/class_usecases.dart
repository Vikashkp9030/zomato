import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/class_entity.dart';
import '../repositories/class_repository.dart';

class ClassUseCases {
  final ClassRepository repository;

  ClassUseCases(this.repository);

  Future<Either<Failure, List<ClassEntity>>> getAllClasses({int page = 1, int limit = 10}) {
    return repository.getAllClasses(page: page, limit: limit);
  }

  Future<Either<Failure, ClassEntity>> getClassById(int id) {
    return repository.getClassById(id);
  }

  Future<Either<Failure, ClassEntity>> createClass(Map<String, dynamic> data) {
    return repository.createClass(data);
  }

  Future<Either<Failure, ClassEntity>> updateClass(int id, Map<String, dynamic> data) {
    return repository.updateClass(id, data);
  }

  Future<Either<Failure, void>> deleteClass(int id) {
    return repository.deleteClass(id);
  }
  Future<Either<Failure, dynamic>> getClassStudents(int classId) {
    return repository.getClassStudents(classId);
  }

  Future<Either<Failure, dynamic>> getClassSubjects(int classId) {
    return repository.getClassSubjects(classId);
  }

}
