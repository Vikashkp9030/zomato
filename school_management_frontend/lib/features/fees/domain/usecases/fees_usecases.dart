import 'package:dartz/dartz.dart';
import '../repositories/fees_repository.dart';
import '../../../../core/error/failures.dart';

class FeesUseCases {
  final FeesRepository repository;

  FeesUseCases(this.repository);

  Future<Either<Failure, List<dynamic>>> getAllFees({int page = 1, int limit = 10}) async {
    return await repository.getAllFees(page: page, limit: limit);
  }

  Future<Either<Failure, List<dynamic>>> getFeesByStatus({
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getAllFees(page: page, limit: limit, status: status);
  }

  Future<Either<Failure, Map<String, dynamic>>> getStudentFees(String studentId) async {
    return await repository.getStudentFees(studentId);
  }

  Future<Either<Failure, Map<String, dynamic>>> getFeeSummary(String studentId) async {
    return await repository.getFeeSummary(studentId);
  }

  Future<Either<Failure, Map<String, dynamic>>> payFee(String feeId, String paymentMethod) async {
    return await repository.payFee(feeId, {'payment_method': paymentMethod});
  }

  Future<Either<Failure, Map<String, dynamic>>> generateReceipt(String feeId) async {
    return await repository.generateReceipt(feeId);
  }

  Future<Either<Failure, Map<String, dynamic>>> createFee({
    required String studentId,
    required double amount,
    required String description,
  }) async {
    return await repository.createFee({
      'student_id': studentId,
      'amount': amount,
      'description': description,
      'due_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    });
  }
}
