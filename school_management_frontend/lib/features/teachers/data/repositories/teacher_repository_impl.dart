import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/teacher_entity.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../datasources/teacher_api_service.dart';
import '../models/teacher_model.dart';
import '../../../classes/domain/entities/class_entity.dart';
import '../../../subjects/domain/entities/subject_entity.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherApiService teacherApiService;
  final Logger _logger = Logger();

  TeacherRepositoryImpl(this.teacherApiService);

  @override
  Future<Either<Failure, List<TeacherEntity>>> getAllTeachers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await teacherApiService.getAllTeachers(page: page, limit: limit);
      final data = response['data'] as List;
      final teachers = data.map((t) => _mapTeacherModelToEntity(TeacherModel.fromJson(t))).toList();
      _logger.i('Fetched ${teachers.length} teachers');
      return Right(teachers);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 0));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch teachers'));
    }
  }

  @override
  Future<Either<Failure, TeacherEntity>> getTeacherById(int id) async {
    try {
      final response = await teacherApiService.getTeacherById(id.toString());
      final teacherModel = TeacherModel.fromJson(response['data']);
      return Right(_mapTeacherModelToEntity(teacherModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch teacher details'));
    }
  }

  @override
  Future<Either<Failure, TeacherEntity>> createTeacher(Map<String, dynamic> data) async {
    try {
      final response = await teacherApiService.createTeacher(data);
      final teacherModel = TeacherModel.fromJson(response['data']);
      _logger.i('Teacher created: ${teacherModel.fullName}');
      return Right(_mapTeacherModelToEntity(teacherModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to create teacher'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error creating teacher'));
    }
  }

  @override
  Future<Either<Failure, TeacherEntity>> updateTeacher(int id, Map<String, dynamic> data) async {
    try {
      final response = await teacherApiService.updateTeacher(id.toString(), data);
      final teacherModel = TeacherModel.fromJson(response['data']);
      _logger.i('Teacher updated: ${teacherModel.fullName}');
      return Right(_mapTeacherModelToEntity(teacherModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to update teacher'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error updating teacher'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeacher(int id) async {
    try {
      await teacherApiService.deleteTeacher(id.toString());
      _logger.i('Teacher deleted: $id');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to delete teacher'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error deleting teacher'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getTeacherClasses(int teacherId) async {
    try {
      final response = await teacherApiService.getTeacherClasses(teacherId.toString());
      final data = response['data'] as List;
      final classes = data
          .map((c) => ClassEntity(
                id: c['id'],
                className: c['class_name'],
                gradeLevel: c['grade_level'],
                section: c['section'],
                capacity: c['capacity'],
                classTeacherId: c['class_teacher_id'],
                roomNumber: c['room_number'],
                currentStudents: c['current_students'] ?? 0,
              ))
          .toList();
      return Right(classes);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch teacher classes'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getTeacherSubjects(int teacherId) async {
    try {
      final response = await teacherApiService.getTeacherSubjects(teacherId.toString());
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
      return Left(NetworkFailure(message: 'Failed to fetch teacher subjects'));
    }
  }

  TeacherEntity _mapTeacherModelToEntity(TeacherModel model) {
    return TeacherEntity(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      phone: model.phone,
      specialization: model.specialization,
      salary: model.salary,
      experienceYears: model.experienceYears,
    );
  }
}
