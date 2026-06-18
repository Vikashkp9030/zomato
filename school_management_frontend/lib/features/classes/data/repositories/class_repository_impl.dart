import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasources/class_api_service.dart';
import '../models/class_model.dart';
import '../../../students/domain/entities/student_entity.dart';
import '../../../subjects/domain/entities/subject_entity.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassApiService classApiService;
  final Logger _logger = Logger();

  ClassRepositoryImpl(this.classApiService);

  @override
  Future<Either<Failure, List<ClassEntity>>> getAllClasses({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await classApiService.getAllClasses(page: page, limit: limit);
      final data = response['data'] as List;
      final classes = data.map((c) => _mapClassModelToEntity(ClassModel.fromJson(c))).toList();
      _logger.i('Fetched ${classes.length} classes');
      return Right(classes);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 0));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch classes'));
    }
  }

  @override
  Future<Either<Failure, ClassEntity>> getClassById(int id) async {
    try {
      final response = await classApiService.getClassById(id.toString());
      final classModel = ClassModel.fromJson(response['data']);
      return Right(_mapClassModelToEntity(classModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch class details'));
    }
  }

  @override
  Future<Either<Failure, ClassEntity>> createClass(Map<String, dynamic> data) async {
    try {
      final response = await classApiService.createClass(data);
      final classModel = ClassModel.fromJson(response['data']);
      _logger.i('Class created: ${classModel.className}');
      return Right(_mapClassModelToEntity(classModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to create class'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error creating class'));
    }
  }

  @override
  Future<Either<Failure, ClassEntity>> updateClass(int id, Map<String, dynamic> data) async {
    try {
      final response = await classApiService.updateClass(id.toString(), data);
      final classModel = ClassModel.fromJson(response['data']);
      _logger.i('Class updated: ${classModel.className}');
      return Right(_mapClassModelToEntity(classModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to update class'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error updating class'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClass(int id) async {
    try {
      await classApiService.deleteClass(id.toString());
      _logger.i('Class deleted: $id');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to delete class'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error deleting class'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getClassStudents(int classId) async {
    try {
      final response = await classApiService.getClassStudents(classId.toString());
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
      return Left(NetworkFailure(message: 'Failed to fetch class students'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getClassSubjects(int classId) async {
    try {
      final response = await classApiService.getClassSubjects(classId.toString());
      final data = response['data'] as List;
      final subjects = data
          .map((s) => SubjectEntity(
                id: s['id'],
                subjectName: s['subject_name'],
                subjectCode: s['subject_code'],
                credits: s['credits'],
                description: s['description'],
              ))
          .toList();
      return Right(subjects);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch class subjects'));
    }
  }

  ClassEntity _mapClassModelToEntity(ClassModel model) {
    return ClassEntity(
      id: model.id,
      className: model.className,
      gradeLevel: model.gradeLevel,
      section: model.section,
      capacity: model.capacity,
      classTeacherId: model.classTeacherId,
      roomNumber: model.roomNumber,
      currentStudents: model.currentStudents,
    );
  }
}
