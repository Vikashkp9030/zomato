import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class AttendanceUseCases {
  final AttendanceRepository repository;

  AttendanceUseCases(this.repository);

  Future<Either<Failure, List<AttendanceEntity>>> getAllAttendance({int page = 1, int limit = 10}) {
    return repository.getAllAttendance(page: page, limit: limit);
  }

  Future<Either<Failure, AttendanceEntity>> getAttendanceById(int id) {
    return repository.getAttendanceById(id);
  }

  Future<Either<Failure, AttendanceEntity>> markAttendance(Map<String, dynamic> data) {
    return repository.markAttendance(data);
  }

  Future<Either<Failure, AttendanceEntity>> updateAttendance(int id, Map<String, dynamic> data) {
    return repository.updateAttendance(id, data);
  }

  Future<Either<Failure, void>> deleteAttendance(int id) {
    return repository.deleteAttendance(id);
  }
  Future<Either<Failure, dynamic>> getStudentAttendance(int studentId) {
    return repository.getStudentAttendance(studentId);
  }

  Future<Either<Failure, dynamic>> getClassAttendance(int classId, {DateTime? date}) {
    return repository.getClassAttendance(classId, date: date);
  }

  Future<Either<Failure, dynamic>> getAttendanceSummary(int studentId) {
    return repository.getAttendanceSummary(studentId);
  }

  Future<Either<Failure, dynamic>> markBulkAttendance(List<Map<String, dynamic>> data) {
    return repository.markBulkAttendance(data);
  }

}
