import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/repositories/subject_repository.dart';
import '../datasources/subject_api_service.dart';
import '../models/subject_model.dart';
import '../../../teachers/domain/entities/teacher_entity.dart';
import '../../../classes/domain/entities/class_entity.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectApiService subjectApiService;
  final Logger _logger = Logger();

  SubjectRepositoryImpl(this.subjectApiService);

  @override
  Future<Either<Failure, List<SubjectEntity>>> getAllSubjects({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await subjectApiService.getAllSubjects(page: page, limit: limit);
      final data = response['data'] as List;
      final subjects = data.map((s) => _mapSubjectModelToEntity(SubjectModel.fromJson(s))).toList();
      _logger.i('Fetched ${subjects.length} subjects');
      return Right(subjects);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 0));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch subjects'));
    }
  }

  @override
  Future<Either<Failure, SubjectEntity>> getSubjectById(int id) async {
    try {
      final response = await subjectApiService.getSubjectById(id.toString());
      final subjectModel = SubjectModel.fromJson(response['data']);
      return Right(_mapSubjectModelToEntity(subjectModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch subject details'));
    }
  }

  @override
  Future<Either<Failure, SubjectEntity>> createSubject(Map<String, dynamic> data) async {
    try {
      final response = await subjectApiService.createSubject(data);
      final subjectModel = SubjectModel.fromJson(response['data']);
      _logger.i('Subject created: ${subjectModel.subjectName}');
      return Right(_mapSubjectModelToEntity(subjectModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to create subject'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error creating subject'));
    }
  }

  @override
  Future<Either<Failure, SubjectEntity>> updateSubject(int id, Map<String, dynamic> data) async {
    try {
      final response = await subjectApiService.updateSubject(id.toString(), data);
      final subjectModel = SubjectModel.fromJson(response['data']);
      _logger.i('Subject updated: ${subjectModel.subjectName}');
      return Right(_mapSubjectModelToEntity(subjectModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to update subject'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error updating subject'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSubject(int id) async {
    try {
      await subjectApiService.deleteSubject(id.toString());
      _logger.i('Subject deleted: $id');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to delete subject'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error deleting subject'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getSubjectTeachers(int subjectId) async {
    try {
      final response = await subjectApiService.getSubjectTeachers(subjectId.toString());
      final data = response['data'] as List;
      final teachers = data
          .map((t) => TeacherEntity(
                id: t['id'],
                firstName: t['first_name'],
                lastName: t['last_name'],
                email: t['email'],
                phone: t['phone'],
                specialization: t['specialization'],
                salary: (t['salary'] as num).toDouble(),
                experienceYears: t['experience_years'],
              ))
          .toList();
      return Right(teachers);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch subject teachers'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getSubjectClasses(int subjectId) async {
    try {
      final response = await subjectApiService.getSubjectClasses(subjectId.toString());
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
      return Left(NetworkFailure(message: 'Failed to fetch subject classes'));
    }
  }

  SubjectEntity _mapSubjectModelToEntity(SubjectModel model) {
    return SubjectEntity(
      id: model.id,
      subjectName: model.subjectName,
      subjectCode: model.subjectCode,
      credits: model.credits,
      description: model.description,
    );
  }
}
