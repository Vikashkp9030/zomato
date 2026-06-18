import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/student_entity.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<StudentEntity>>> getAllStudents({int page = 1, int limit = 10});
  Future<Either<Failure, StudentEntity>> getStudentById(int id);
  Future<Either<Failure, StudentEntity>> createStudent(Map<String, dynamic> data);
  Future<Either<Failure, StudentEntity>> updateStudent(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteStudent(int id);
  Future<Either<Failure, dynamic>> getStudentPerformance(int studentId);
  Future<Either<Failure, dynamic>> getStudentResults(int studentId);
  Future<Either<Failure, dynamic>> getStudentAttendance(int studentId);
}
