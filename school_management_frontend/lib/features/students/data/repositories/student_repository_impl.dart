import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/entities/student_performance_entity.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_api_service.dart';
import '../models/student_model.dart';
import '../../../exam_results/domain/entities/exam_result_entity.dart';
import '../../../attendance/domain/entities/attendance_summary_entity.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentApiService studentApiService;
  final Logger _logger = Logger();

  StudentRepositoryImpl(this.studentApiService);

  @override
  Future<Either<Failure, List<StudentEntity>>> getAllStudents({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await studentApiService.getAllStudents(page: page, limit: limit);
      final data = response['data'] as List;
      final students = data.map((s) => _mapStudentModelToEntity(StudentModel.fromJson(s))).toList();
      _logger.i('Fetched ${students.length} students');
      return Right(students);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 0));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch students'));
    }
  }

  @override
  Future<Either<Failure, StudentEntity>> getStudentById(int id) async {
    try {
      final response = await studentApiService.getStudentById(id.toString());
      final studentModel = StudentModel.fromJson(response['data']);
      return Right(_mapStudentModelToEntity(studentModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch student details'));
    }
  }

  @override
  Future<Either<Failure, StudentEntity>> createStudent(Map<String, dynamic> data) async {
    try {
      final response = await studentApiService.createStudent(data);
      final studentModel = StudentModel.fromJson(response['data']);
      _logger.i('Student created: ${studentModel.fullName}');
      return Right(_mapStudentModelToEntity(studentModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to create student'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error creating student'));
    }
  }

  @override
  Future<Either<Failure, StudentEntity>> updateStudent(int id, Map<String, dynamic> data) async {
    try {
      final response = await studentApiService.updateStudent(id.toString(), data);
      final studentModel = StudentModel.fromJson(response['data']);
      _logger.i('Student updated: ${studentModel.fullName}');
      return Right(_mapStudentModelToEntity(studentModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to update student'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error updating student'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudent(int id) async {
    try {
      await studentApiService.deleteStudent(id.toString());
      _logger.i('Student deleted: $id');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to delete student'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error deleting student'));
    }
  }

  @override
  Future<Either<Failure, StudentPerformanceEntity>> getStudentPerformance(int studentId) async {
    try {
      final response = await studentApiService.getStudentPerformance(studentId.toString());
      final perfModel = StudentPerformanceModel.fromJson(response['data']);
      return Right(_mapPerformanceModelToEntity(perfModel));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch student performance'));
    }
  }

  @override
  Future<Either<Failure, List<ExamResultEntity>>> getStudentResults(int studentId) async {
    try {
      final response = await studentApiService.getStudentResults(studentId.toString());
      final data = response['data'] as List;
      final results = data
          .map((r) => ExamResultEntity(
                id: r['id'],
                examId: r['exam_id'],
                studentId: r['student_id'],
                marksObtained: (r['marks_obtained'] as num).toDouble(),
                grade: r['grade'],
                status: r['status'],
                attempt: r['attempt'],
              ))
          .toList();
      return Right(results);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch student results'));
    }
  }

  @override
  Future<Either<Failure, AttendanceSummaryEntity>> getStudentAttendance(int studentId) async {
    try {
      final response = await studentApiService.getStudentAttendance(studentId.toString());
      final attendanceData = response['data'];
      return Right(AttendanceSummaryEntity(
        studentId: attendanceData['student_id'],
        totalDays: attendanceData['total_days'],
        presentDays: attendanceData['present_days'],
        absentDays: attendanceData['absent_days'],
        leaveDays: attendanceData['leave_days'],
        attendancePercentage: (attendanceData['attendance_percentage'] as num).toDouble(),
      ));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch student attendance'));
    }
  }

  StudentEntity _mapStudentModelToEntity(StudentModel model) {
    return StudentEntity(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      phone: model.phone,
      dateOfBirth: model.dateOfBirth,
      gender: model.gender,
      classId: model.classId,
      status: model.status,
    );
  }

  StudentPerformanceEntity _mapPerformanceModelToEntity(StudentPerformanceModel model) {
    return StudentPerformanceEntity(
      studentId: model.studentId,
      studentName: model.studentName,
      gpa: model.gpa,
      averageMarks: model.averageMarks,
      totalExams: model.totalExams,
      passedExams: model.passedExams,
      failedExams: model.failedExams,
      attendancePercentage: model.attendancePercentage,
    );
  }
}
