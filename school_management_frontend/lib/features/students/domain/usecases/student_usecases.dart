import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/student_entity.dart';
import '../repositories/student_repository.dart';

class StudentUseCases {
  final StudentRepository repository;

  StudentUseCases(this.repository);

  Future<Either<Failure, List<StudentEntity>>> getAllStudents({int page = 1, int limit = 10}) {
    return repository.getAllStudents(page: page, limit: limit);
  }

  Future<Either<Failure, StudentEntity>> getStudentById(int id) {
    return repository.getStudentById(id);
  }

  Future<Either<Failure, StudentEntity>> createStudent(Map<String, dynamic> data) {
    return repository.createStudent(data);
  }

  Future<Either<Failure, StudentEntity>> updateStudent(int id, Map<String, dynamic> data) {
    return repository.updateStudent(id, data);
  }

  Future<Either<Failure, void>> deleteStudent(int id) {
    return repository.deleteStudent(id);
  }

  Future<Either<Failure, dynamic>> getStudentPerformance(int studentId) {
    return repository.getStudentPerformance(studentId);
  }

  Future<Either<Failure, dynamic>> getStudentResults(int studentId) {
    return repository.getStudentResults(studentId);
  }

  Future<Either<Failure, dynamic>> getStudentAttendance(int studentId) {
    return repository.getStudentAttendance(studentId);
  }
}
