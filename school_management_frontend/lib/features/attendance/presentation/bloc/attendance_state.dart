import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_summary_entity.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceEntity> attendance;

  const AttendanceLoaded({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

class AttendanceItemLoaded extends AttendanceState {
  final AttendanceEntity attendance;

  const AttendanceItemLoaded({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

class AttendanceMarked extends AttendanceState {
  final AttendanceEntity attendance;

  const AttendanceMarked({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

class AttendanceUpdated extends AttendanceState {
  final AttendanceEntity attendance;

  const AttendanceUpdated({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

class AttendanceDeleted extends AttendanceState {
  const AttendanceDeleted();
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError({required this.message});

  @override
  List<Object?> get props => [message];
}

class StudentAttendanceLoaded extends AttendanceState {
  final List<AttendanceEntity> attendance;

  const StudentAttendanceLoaded({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

class ClassAttendanceLoaded extends AttendanceState {
  final List<AttendanceEntity> attendance;

  const ClassAttendanceLoaded({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

class AttendanceSummaryLoaded extends AttendanceState {
  final AttendanceSummaryEntity summary;

  const AttendanceSummaryLoaded({required this.summary});

  @override
  List<Object?> get props => [summary];
}

class BulkAttendanceMarked extends AttendanceState {
  final Map<String, dynamic> result;

  const BulkAttendanceMarked({required this.result});

  @override
  List<Object?> get props => [result];
}
