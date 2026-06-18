import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class FetchDashboardStatsEvent extends DashboardEvent {
  const FetchDashboardStatsEvent();
}

class FetchWeeklyAttendanceEvent extends DashboardEvent {
  const FetchWeeklyAttendanceEvent();
}

class FetchClassPerformanceEvent extends DashboardEvent {
  const FetchClassPerformanceEvent();
}

class FetchUpcomingExamsEvent extends DashboardEvent {
  const FetchUpcomingExamsEvent();
}

class FetchPendingFeesEvent extends DashboardEvent {
  const FetchPendingFeesEvent();
}

class FetchNotificationsEvent extends DashboardEvent {
  const FetchNotificationsEvent();
}

class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();
}