import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/attendance_usecases.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceUseCases useCases;

  AttendanceBloc(this.useCases) : super(const AttendanceInitial()) {
    on<GetAllAttendanceEvent>(_onGetAllAttendance);
    on<GetAttendanceByIdEvent>(_onGetAttendanceById);
    on<MarkAttendanceEvent>(_onMarkAttendance);
    on<UpdateAttendanceEvent>(_onUpdateAttendance);
    on<DeleteAttendanceEvent>(_onDeleteAttendance);
    on<GetStudentAttendanceEvent>(_onGetStudentAttendance);
    on<GetClassAttendanceEvent>(_onGetClassAttendance);
    on<GetAttendanceSummaryEvent>(_onGetAttendanceSummary);
    on<MarkBulkAttendanceEvent>(_onMarkBulkAttendance);
  }

  Future<void> _onGetAllAttendance(
    GetAllAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    final result = await useCases.getAllAttendance(
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (attendance) => emit(AttendanceLoaded(attendance: attendance)),
    );
  }

  Future<void> _onGetAttendanceById(
    GetAttendanceByIdEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    final result = await useCases.getAttendanceById(event.id);
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (attendance) => emit(AttendanceItemLoaded(attendance: attendance)),
    );
  }

  Future<void> _onMarkAttendance(
    MarkAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    final result = await useCases.markAttendance(event.data);
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (attendance) => emit(AttendanceMarked(attendance: attendance)),
    );
  }

  Future<void> _onUpdateAttendance(
    UpdateAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    final result = await useCases.updateAttendance(event.id, event.data);
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (attendance) => emit(AttendanceUpdated(attendance: attendance)),
    );
  }

  Future<void> _onDeleteAttendance(
    DeleteAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    final result = await useCases.deleteAttendance(event.id);
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (_) => emit(const AttendanceDeleted()),
    );
  }

  Future<void> _onGetStudentAttendance(
    GetStudentAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    final result = await useCases.getStudentAttendance(event.studentId);
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (attendance) => emit(StudentAttendanceLoaded(attendance: attendance)),
    );
  }

  Future<void> _onGetClassAttendance(
    GetClassAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    final result = await useCases.getClassAttendance(event.classId, date: event.date);
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (attendance) => emit(ClassAttendanceLoaded(attendance: attendance)),
    );
  }

  Future<void> _onGetAttendanceSummary(
    GetAttendanceSummaryEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    final result = await useCases.getAttendanceSummary(event.studentId);
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (summary) => emit(AttendanceSummaryLoaded(summary: summary)),
    );
  }

  Future<void> _onMarkBulkAttendance(
    MarkBulkAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    final result = await useCases.markBulkAttendance(event.data);
    result.fold(
      (failure) => emit(AttendanceError(message: failure.message)),
      (result) => emit(BulkAttendanceMarked(result: result)),
    );
  }
}
