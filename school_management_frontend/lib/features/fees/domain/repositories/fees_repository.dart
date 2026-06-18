import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class FeesRepository {
  Future<Either<Failure, List<dynamic>>> getAllFees({int page, int limit, String? status});
  Future<Either<Failure, Map<String, dynamic>>> getStudentFees(String studentId);
  Future<Either<Failure, Map<String, dynamic>>> getFeeSummary(String studentId);
  Future<Either<Failure, Map<String, dynamic>>> payFee(String feeId, Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> generateReceipt(String feeId);
  Future<Either<Failure, Map<String, dynamic>>> createFee(Map<String, dynamic> data);
}
