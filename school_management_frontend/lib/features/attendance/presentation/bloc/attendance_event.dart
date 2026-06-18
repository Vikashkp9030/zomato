import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class GetAllAttendanceEvent extends AttendanceEvent {
  final int page;
  final int limit;

  const GetAllAttendanceEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class GetAttendanceByIdEvent extends AttendanceEvent {
  final int id;

  const GetAttendanceByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAttendanceEvent extends AttendanceEvent {
  final Map<String, dynamic> data;

  const MarkAttendanceEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateAttendanceEvent extends AttendanceEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateAttendanceEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteAttendanceEvent extends AttendanceEvent {
  final int id;

  const DeleteAttendanceEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetStudentAttendanceEvent extends AttendanceEvent {
  final int studentId;

  const GetStudentAttendanceEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class GetClassAttendanceEvent extends AttendanceEvent {
  final int classId;
  final DateTime? date;

  const GetClassAttendanceEvent(this.classId, {this.date});

  @override
  List<Object?> get props => [classId, date];
}

class GetAttendanceSummaryEvent extends AttendanceEvent {
  final int studentId;

  const GetAttendanceSummaryEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class MarkBulkAttendanceEvent extends AttendanceEvent {
  final List<Map<String, dynamic>> data;

  const MarkBulkAttendanceEvent(this.data);

  @override
  List<Object?> get props => [data];
}
