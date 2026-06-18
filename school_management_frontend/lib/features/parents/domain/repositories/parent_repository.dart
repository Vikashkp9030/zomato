import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parent_entity.dart';

abstract class ParentRepository {
  Future<Either<Failure, List<ParentEntity>>> getAllParents({int page = 1, int limit = 10});
  Future<Either<Failure, ParentEntity>> getParentById(int id);
  Future<Either<Failure, ParentEntity>> createParent(Map<String, dynamic> data);
  Future<Either<Failure, ParentEntity>> updateParent(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteParent(int id);
  Future<Either<Failure, List<dynamic>>> getParentChildren(int parentId);
  Future<Either<Failure, dynamic>> linkParentToStudent(int parentId, int studentId);
  Future<Either<Failure, dynamic>> unlinkParentFromStudent(int parentId, int studentId);
}
