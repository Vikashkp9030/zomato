import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/fees_repository.dart';
import '../datasources/fees_api_service.dart';

class FeesRepositoryImpl implements FeesRepository {
  final FeesApiService apiService;
  final Logger _logger = Logger();

  FeesRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<dynamic>>> getAllFees({int page = 1, int limit = 10, String? status}) async {
    try {
      final response = await apiService.getAllFees(page: page, limit: limit, status: status);
      final data = response['data'] as List;
      _logger.i('Fetched ${data.length} fees');
      return Right(data);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch fees'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStudentFees(String studentId) async {
    try {
      final response = await apiService.getStudentFees(studentId);
      return Right(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch student fees'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getFeeSummary(String studentId) async {
    try {
      final response = await apiService.getFeeSummary(studentId);
      return Right(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch fee summary'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> payFee(String feeId, Map<String, dynamic> data) async {
    try {
      final response = await apiService.payFee(feeId, data);
      _logger.i('Fee payment successful');
      return Right(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Payment failed';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error processing payment'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> generateReceipt(String feeId) async {
    try {
      final response = await apiService.generateReceipt(feeId);
      return Right(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to generate receipt'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createFee(Map<String, dynamic> data) async {
    try {
      final response = await apiService.createFee(data);
      _logger.i('Fee created successfully');
      return Right(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to create fee'));
    }
  }
}
