import 'package:dartz/dartz.dart';
import '../repositories/dashboard_repository.dart';
import '../../../../core/error/failures.dart';

class DashboardUseCases {
  final DashboardRepository repository;

  DashboardUseCases(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    return await repository.getDashboardStats();
  }

  Future<Either<Failure, List<dynamic>>> getWeeklyAttendance() async {
    return await repository.getWeeklyAttendance();
  }

  Future<Either<Failure, List<dynamic>>> getClassPerformance() async {
    return await repository.getClassPerformance();
  }

  Future<Either<Failure, List<dynamic>>> getUpcomingExams() async {
    return await repository.getUpcomingExams();
  }

  Future<Either<Failure, List<dynamic>>> getPendingFees() async {
    return await repository.getPendingFees();
  }

  Future<Either<Failure, List<dynamic>>> getNotifications() async {
    return await repository.getNotifications();
  }
}