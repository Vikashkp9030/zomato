import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<AttendanceEntity>>> getAllAttendance({int page = 1, int limit = 10});
  Future<Either<Failure, AttendanceEntity>> getAttendanceById(int id);
  Future<Either<Failure, AttendanceEntity>> markAttendance(Map<String, dynamic> data);
  Future<Either<Failure, AttendanceEntity>> updateAttendance(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteAttendance(int id);
  Future<Either<Failure, dynamic>> getStudentAttendance(int studentId);
  Future<Either<Failure, dynamic>> getClassAttendance(int classId, {DateTime? date});
  Future<Either<Failure, dynamic>> getAttendanceSummary(int studentId);
  Future<Either<Failure, dynamic>> markBulkAttendance(List<Map<String, dynamic>> data);
}
