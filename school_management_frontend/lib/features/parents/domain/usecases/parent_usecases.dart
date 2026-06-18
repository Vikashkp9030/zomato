import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parent_entity.dart';
import '../repositories/parent_repository.dart';

class ParentUseCases {
  final ParentRepository repository;

  ParentUseCases(this.repository);

  Future<Either<Failure, List<ParentEntity>>> getAllParents({int page = 1, int limit = 10}) {
    return repository.getAllParents(page: page, limit: limit);
  }

  Future<Either<Failure, ParentEntity>> getParentById(int id) {
    return repository.getParentById(id);
  }

  Future<Either<Failure, ParentEntity>> createParent(Map<String, dynamic> data) {
    return repository.createParent(data);
  }

  Future<Either<Failure, ParentEntity>> updateParent(int id, Map<String, dynamic> data) {
    return repository.updateParent(id, data);
  }

  Future<Either<Failure, void>> deleteParent(int id) {
    return repository.deleteParent(id);
  }

  Future<Either<Failure, dynamic>> getParentChildren(int parentId) {
    return repository.getParentChildren(parentId);
  }

  Future<Either<Failure, dynamic>> linkParentToStudent(int parentId, int studentId) {
    return repository.linkParentToStudent(parentId, studentId);
  }

  Future<Either<Failure, dynamic>> unlinkParentFromStudent(int parentId, int studentId) {
    return repository.unlinkParentFromStudent(parentId, studentId);
  }
}
