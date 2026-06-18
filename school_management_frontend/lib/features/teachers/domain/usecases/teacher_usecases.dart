import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/teacher_entity.dart';
import '../repositories/teacher_repository.dart';

class TeacherUseCases {
  final TeacherRepository repository;

  TeacherUseCases(this.repository);

  Future<Either<Failure, List<TeacherEntity>>> getAllTeachers({int page = 1, int limit = 10}) {
    return repository.getAllTeachers(page: page, limit: limit);
  }

  Future<Either<Failure, TeacherEntity>> getTeacherById(int id) {
    return repository.getTeacherById(id);
  }

  Future<Either<Failure, TeacherEntity>> createTeacher(Map<String, dynamic> data) {
    return repository.createTeacher(data);
  }

  Future<Either<Failure, TeacherEntity>> updateTeacher(int id, Map<String, dynamic> data) {
    return repository.updateTeacher(id, data);
  }

  Future<Either<Failure, void>> deleteTeacher(int id) {
    return repository.deleteTeacher(id);
  }

  Future<Either<Failure, dynamic>> getTeacherClasses(int teacherId) {
    return repository.getTeacherClasses(teacherId);
  }

  Future<Either<Failure, dynamic>> getTeacherSubjects(int teacherId) {
    return repository.getTeacherSubjects(teacherId);
  }
}
