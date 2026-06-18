import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/dashboard_usecases.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardUseCases useCases;
  final Logger _logger = Logger();

  DashboardBloc(this.useCases) : super(const DashboardInitialState()) {
    on<FetchDashboardStatsEvent>(_onFetchStats);
    on<FetchWeeklyAttendanceEvent>(_onFetchWeeklyAttendance);
    on<FetchClassPerformanceEvent>(_onFetchClassPerformance);
    on<FetchUpcomingExamsEvent>(_onFetchUpcomingExams);
    on<FetchPendingFeesEvent>(_onFetchPendingFees);
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onFetchStats(
    FetchDashboardStatsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final result = await useCases.getDashboardStats();
    result.fold(
      (failure) {
        _logger.e('Error fetching stats: ${failure.message}');
        emit(DashboardErrorState(message: failure.message));
      },
      (stats) {
        _logger.i('Stats loaded successfully');
        emit(DashboardStatsLoadedState(stats: stats));
      },
    );
  }

  Future<void> _onFetchWeeklyAttendance(
    FetchWeeklyAttendanceEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final result = await useCases.getWeeklyAttendance();
    result.fold(
      (failure) {
        _logger.e('Error fetching attendance: ${failure.message}');
        emit(DashboardErrorState(message: failure.message));
      },
      (attendance) {
        _logger.i('Attendance data loaded');
        emit(DashboardAttendanceLoadedState(attendance: attendance));
      },
    );
  }

  Future<void> _onFetchClassPerformance(
    FetchClassPerformanceEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final result = await useCases.getClassPerformance();
    result.fold(
      (failure) {
        _logger.e('Error fetching performance: ${failure.message}');
        emit(DashboardErrorState(message: failure.message));
      },
      (performance) {
        _logger.i('Performance data loaded');
        emit(DashboardPerformanceLoadedState(performance: performance));
      },
    );
  }

  Future<void> _onFetchUpcomingExams(
    FetchUpcomingExamsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final result = await useCases.getUpcomingExams();
    result.fold(
      (failure) {
        _logger.e('Error fetching exams: ${failure.message}');
        emit(DashboardErrorState(message: failure.message));
      },
      (exams) {
        _logger.i('Upcoming exams loaded');
        emit(DashboardAttendanceLoadedState(attendance: exams));
      },
    );
  }

  Future<void> _onFetchPendingFees(
    FetchPendingFeesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final result = await useCases.getPendingFees();
    result.fold(
      (failure) {
        _logger.e('Error fetching fees: ${failure.message}');
        emit(DashboardErrorState(message: failure.message));
      },
      (fees) {
        _logger.i('Pending fees loaded');
        emit(DashboardAttendanceLoadedState(attendance: fees));
      },
    );
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final result = await useCases.getNotifications();
    result.fold(
      (failure) {
        _logger.e('Error fetching notifications: ${failure.message}');
        emit(DashboardErrorState(message: failure.message));
      },
      (notifications) {
        _logger.i('Notifications loaded');
        emit(DashboardAttendanceLoadedState(attendance: notifications));
      },
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final statsResult = await useCases.getDashboardStats();
    final attendanceResult = await useCases.getWeeklyAttendance();
    final performanceResult = await useCases.getClassPerformance();
    final examsResult = await useCases.getUpcomingExams();
    final feesResult = await useCases.getPendingFees();
    final notificationsResult = await useCases.getNotifications();

    var allSuccess = true;
    var stats = <String, dynamic>{};
    var attendance = <dynamic>[];
    var performance = <dynamic>[];
    var exams = <dynamic>[];
    var fees = <dynamic>[];
    var notifications = <dynamic>[];

    statsResult.fold(
      (failure) => allSuccess = false,
      (data) => stats = data,
    );
    attendanceResult.fold(
      (failure) => allSuccess = false,
      (data) => attendance = data,
    );
    performanceResult.fold(
      (failure) => allSuccess = false,
      (data) => performance = data,
    );
    examsResult.fold(
      (failure) => allSuccess = false,
      (data) => exams = data,
    );
    feesResult.fold(
      (failure) => allSuccess = false,
      (data) => fees = data,
    );
    notificationsResult.fold(
      (failure) => allSuccess = false,
      (data) => notifications = data,
    );

    if (allSuccess) {
      _logger.i('Dashboard refreshed successfully');
      emit(DashboardLoadedState(
        stats: stats,
        weeklyAttendance: attendance,
        classPerformance: performance,
        upcomingExams: exams,
        pendingFees: fees,
        notifications: notifications,
      ));
    } else {
      emit(const DashboardErrorState(message: 'Failed to refresh dashboard'));
    }
  }
}