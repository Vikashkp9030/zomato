import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/class_entity.dart';

abstract class ClassRepository {
  Future<Either<Failure, List<ClassEntity>>> getAllClasses({int page = 1, int limit = 10});
  Future<Either<Failure, ClassEntity>> getClassById(int id);
  Future<Either<Failure, ClassEntity>> createClass(Map<String, dynamic> data);
  Future<Either<Failure, ClassEntity>> updateClass(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteClass(int id);
  Future<Either<Failure, dynamic>> getClassStudents(int classId);
  Future<Either<Failure, dynamic>> getClassSubjects(int classId);
}
