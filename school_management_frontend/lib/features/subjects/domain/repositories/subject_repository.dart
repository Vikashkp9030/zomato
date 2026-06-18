import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/subject_entity.dart';

abstract class SubjectRepository {
  Future<Either<Failure, List<SubjectEntity>>> getAllSubjects({int page = 1, int limit = 10});
  Future<Either<Failure, SubjectEntity>> getSubjectById(int id);
  Future<Either<Failure, SubjectEntity>> createSubject(Map<String, dynamic> data);
  Future<Either<Failure, SubjectEntity>> updateSubject(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteSubject(int id);
  Future<Either<Failure, List<dynamic>>> getSubjectTeachers(int subjectId);
  Future<Either<Failure, List<dynamic>>> getSubjectClasses(int subjectId);
}
