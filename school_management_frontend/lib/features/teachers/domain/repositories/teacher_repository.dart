import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/teacher_entity.dart';

abstract class TeacherRepository {
  Future<Either<Failure, List<TeacherEntity>>> getAllTeachers({int page = 1, int limit = 10});
  Future<Either<Failure, TeacherEntity>> getTeacherById(int id);
  Future<Either<Failure, TeacherEntity>> createTeacher(Map<String, dynamic> data);
  Future<Either<Failure, TeacherEntity>> updateTeacher(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteTeacher(int id);
  Future<Either<Failure, List<dynamic>>> getTeacherClasses(int teacherId);
  Future<Either<Failure, List<dynamic>>> getTeacherSubjects(int teacherId);
}
