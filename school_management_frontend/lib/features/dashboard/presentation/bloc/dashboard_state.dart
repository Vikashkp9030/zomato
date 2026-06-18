import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {
  const DashboardInitialState();
}

class DashboardLoadingState extends DashboardState {
  const DashboardLoadingState();
}

class DashboardLoadedState extends DashboardState {
  final Map<String, dynamic> stats;
  final List<dynamic> weeklyAttendance;
  final List<dynamic> classPerformance;
  final List<dynamic> upcomingExams;
  final List<dynamic> pendingFees;
  final List<dynamic> notifications;

  const DashboardLoadedState({
    required this.stats,
    required this.weeklyAttendance,
    required this.classPerformance,
    required this.upcomingExams,
    required this.pendingFees,
    required this.notifications,
  });

  @override
  List<Object?> get props => [
    stats,
    weeklyAttendance,
    classPerformance,
    upcomingExams,
    pendingFees,
    notifications,
  ];
}

class DashboardStatsLoadedState extends DashboardState {
  final Map<String, dynamic> stats;

  const DashboardStatsLoadedState({required this.stats});

  @override
  List<Object?> get props => [stats];
}

class DashboardAttendanceLoadedState extends DashboardState {
  final List<dynamic> attendance;

  const DashboardAttendanceLoadedState({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

class DashboardPerformanceLoadedState extends DashboardState {
  final List<dynamic> performance;

  const DashboardPerformanceLoadedState({required this.performance});

  @override
  List<Object?> get props => [performance];
}

class DashboardErrorState extends DashboardState {
  final String message;

  const DashboardErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}