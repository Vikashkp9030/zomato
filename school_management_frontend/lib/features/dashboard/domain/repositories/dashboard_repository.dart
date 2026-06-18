import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats();
  Future<Either<Failure, List<dynamic>>> getWeeklyAttendance();
  Future<Either<Failure, List<dynamic>>> getClassPerformance();
  Future<Either<Failure, List<dynamic>>> getUpcomingExams();
  Future<Either<Failure, List<dynamic>>> getPendingFees();
  Future<Either<Failure, List<dynamic>>> getNotifications();
}