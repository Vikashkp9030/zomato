import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_api_service.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardApiService dashboardApiService;
  final Logger _logger = Logger();

  DashboardRepositoryImpl(this.dashboardApiService);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    try {
      final response = await dashboardApiService.getDashboardStats();
      _logger.i('Dashboard stats fetched successfully');
      return Right(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch dashboard stats'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getWeeklyAttendance() async {
    try {
      final response = await dashboardApiService.getWeeklyAttendance();
      final data = response['data'] as List;
      return Right(data);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch weekly attendance'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getClassPerformance() async {
    try {
      final response = await dashboardApiService.getClassPerformance();
      final data = response['data'] as List;
      return Right(data);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch class performance'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getUpcomingExams() async {
    try {
      final response = await dashboardApiService.getUpcomingExams();
      final data = response['data'] as List;
      return Right(data);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch upcoming exams'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getPendingFees() async {
    try {
      final response = await dashboardApiService.getPendingFees();
      final data = response['data'] as List;
      return Right(data);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch pending fees'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getNotifications() async {
    try {
      final response = await dashboardApiService.getNotifications();
      final data = response['data'] as List;
      return Right(data);
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch notifications'));
    }
  }
}