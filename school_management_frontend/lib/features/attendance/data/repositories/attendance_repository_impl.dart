import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_summary_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_api_service.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceApiService attendanceApiService;
  final Logger _logger = Logger();

  AttendanceRepositoryImpl(this.attendanceApiService);

  @override
  Future<Either<Failure, List<AttendanceEntity>>> getAllAttendance({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await attendanceApiService.getAllAttendance(page: page, limit: limit);
      final data = response['data'] as List;
      final attendance = data
          .map((a) => AttendanceEntity(
                id: a['id'],
                studentId: a['student_id'],
                classId: a['class_id'],
                attendanceDate: DateTime.parse(a['attendance_date']),
                status: a['status'],
                remarks: a['remarks'],
              ))
          .toList();
      _logger.i('Fetched ${attendance.length} attendance records');
      return Right(attendance);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 0));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch attendance'));
    }
  }

  @override
  Future<Either<Failure, AttendanceEntity>> getAttendanceById(int id) async {
    try {
      final response = await attendanceApiService.getAttendanceById(id.toString());
      final data = response['data'];
      return Right(AttendanceEntity(
        id: data['id'],
        studentId: data['student_id'],
        classId: data['class_id'],
        attendanceDate: DateTime.parse(data['attendance_date']),
        status: data['status'],
        remarks: data['remarks'],
      ));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch attendance details'));
    }
  }

  @override
  Future<Either<Failure, AttendanceEntity>> markAttendance(Map<String, dynamic> data) async {
    try {
      final response = await attendanceApiService.markAttendance(data);
      final attendanceData = response['data'];
      _logger.i('Attendance marked for student: ${attendanceData['student_id']}');
      return Right(AttendanceEntity(
        id: attendanceData['id'],
        studentId: attendanceData['student_id'],
        classId: attendanceData['class_id'],
        attendanceDate: DateTime.parse(attendanceData['attendance_date']),
        status: attendanceData['status'],
        remarks: attendanceData['remarks'],
      ));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to mark attendance'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error marking attendance'));
    }
  }

  @override
  Future<Either<Failure, AttendanceEntity>> updateAttendance(int id, Map<String, dynamic> data) async {
    try {
      final response = await attendanceApiService.updateAttendance(id.toString(), data);
      final attendanceData = response['data'];
      _logger.i('Attendance updated: $id');
      return Right(AttendanceEntity(
        id: attendanceData['id'],
        studentId: attendanceData['student_id'],
        classId: attendanceData['class_id'],
        attendanceDate: DateTime.parse(attendanceData['attendance_date']),
        status: attendanceData['status'],
        remarks: attendanceData['remarks'],
      ));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to update attendance'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error updating attendance'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttendance(int id) async {
    try {
      await attendanceApiService.deleteAttendance(id.toString());
      _logger.i('Attendance deleted: $id');
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to delete attendance'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error deleting attendance'));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceEntity>>> getStudentAttendance(int studentId) async {
    try {
      final response = await attendanceApiService.getStudentAttendance(studentId.toString());
      final data = response['data'] as List;
      final attendance = data
          .map((a) => AttendanceEntity(
                id: a['id'],
                studentId: a['student_id'],
                classId: a['class_id'],
                attendanceDate: DateTime.parse(a['attendance_date']),
                status: a['status'],
                remarks: a['remarks'],
              ))
          .toList();
      return Right(attendance);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch student attendance'));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceEntity>>> getClassAttendance(int classId, {DateTime? date}) async {
    try {
      final response = await attendanceApiService.getClassAttendance(
        classId.toString(),
        date: date?.toIso8601String(),
      );
      final data = response['data'] as List;
      final attendance = data
          .map((a) => AttendanceEntity(
                id: a['id'],
                studentId: a['student_id'],
                classId: a['class_id'],
                attendanceDate: DateTime.parse(a['attendance_date']),
                status: a['status'],
                remarks: a['remarks'],
              ))
          .toList();
      return Right(attendance);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch class attendance'));
    }
  }

  @override
  Future<Either<Failure, AttendanceSummaryEntity>> getAttendanceSummary(int studentId) async {
    try {
      final response = await attendanceApiService.getAttendanceSummary(studentId.toString());
      final summary = response['data'];
      return Right(AttendanceSummaryEntity(
        studentId: summary['student_id'],
        totalDays: summary['total_days'],
        presentDays: summary['present_days'],
        absentDays: summary['absent_days'],
        leaveDays: summary['leave_days'],
        attendancePercentage: (summary['attendance_percentage'] as num).toDouble(),
      ));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch attendance summary'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markBulkAttendance(List<Map<String, dynamic>> data) async {
    try {
      final response = await attendanceApiService.markBulkAttendance(data);
      _logger.i('Bulk attendance marked for ${data.length} records');
      return Right(response['data']);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Failed to mark bulk attendance'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error marking bulk attendance'));
    }
  }
}
