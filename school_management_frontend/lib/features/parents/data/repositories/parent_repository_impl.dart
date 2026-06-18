import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/parent_entity.dart';
import '../../domain/repositories/parent_repository.dart';
import '../datasources/parent_api_service.dart';
import '../../../students/domain/entities/student_entity.dart';
import '../models/parent_model.dart';

class ParentRepositoryImpl implements ParentRepository {
  final ParentApiService parentApiService;
  final Logger _logger = Logger();

  ParentRepositoryImpl(this.parentApiService);

  @override
  Future<Either<Failure, List<ParentEntity>>> getAllParents({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await parentApiService.getAllParents(page: page, limit: limit);
      final data = response['data'] as List;
      final parents = data.map((p) => _mapParentModelToEntity(ParentModel.fromJson(p))).toList();
      _logger.i('Fetched ${parents.length} parents');
      return Right(parents);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 0));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch parents'));
    }
  }

  @override
  Future<Either<Failure, ParentEntity>> getParentById(int id) async {
    try {
      final response = await parentApiService.getParentById(id.toString());
      final parentModel = ParentModel.fromJson(response['data']);
      return Right(_mapParentModelToEntity(parentModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch parent details'));
    }
  }

  @override
  Future<Either<Failure, ParentEntity>> createParent(Map<String, dynamic> data) async {
    try {
      final response = await parentApiService.createParent(data);
      final parentModel = ParentModel.fromJson(response['data']);
      _logger.i('Parent created: ${parentModel.parentName}');
      return Right(_mapParentModelToEntity(parentModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to create parent'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error creating parent'));
    }
  }

  @override
  Future<Either<Failure, ParentEntity>> updateParent(int id, Map<String, dynamic> data) async {
    try {
      final response = await parentApiService.updateParent(id.toString(), data);
      final parentModel = ParentModel.fromJson(response['data']);
      _logger.i('Parent updated: ${parentModel.parentName}');
      return Right(_mapParentModelToEntity(parentModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to update parent'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error updating parent'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteParent(int id) async {
    try {
      await parentApiService.deleteParent(id.toString());
      _logger.i('Parent deleted: $id');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to delete parent'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error deleting parent'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getParentChildren(int parentId) async {
    try {
      final response = await parentApiService.getParentChildren(parentId.toString());
      final data = response['data'] as List;
      final students = data
          .map((s) => StudentEntity(
                id: s['id'],
                firstName: s['first_name'],
                lastName: s['last_name'],
                email: s['email'],
                phone: s['phone'],
                dateOfBirth: DateTime.parse(s['date_of_birth']),
                gender: s['gender'],
                classId: s['class_id'],
                status: s['status'],
              ))
          .toList();
      return Right(students);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch parent children'));
    }
  }

  @override
  Future<Either<Failure, void>> linkParentToStudent(int parentId, int studentId) async {
    try {
      await parentApiService.linkParentToStudent(parentId.toString(), studentId.toString());
      _logger.i('Parent $parentId linked to student $studentId');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to link parent'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error linking parent to student'));
    }
  }

  @override
  Future<Either<Failure, void>> unlinkParentFromStudent(int parentId, int studentId) async {
    try {
      await parentApiService.unlinkParentFromStudent(parentId.toString(), studentId.toString());
      _logger.i('Parent $parentId unlinked from student $studentId');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to unlink parent'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error unlinking parent from student'));
    }
  }

  ParentEntity _mapParentModelToEntity(ParentModel model) {
    return ParentEntity(
      id: model.id,
      studentId: model.studentId,
      parentName: model.parentName,
      relationship: model.relationship,
      phone: model.phone,
      email: model.email,
      occupation: model.occupation,
    );
  }
}
