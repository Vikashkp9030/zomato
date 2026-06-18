import 'package:equatable/equatable.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

class GetAllStudentsEvent extends StudentEvent {
  final int page;
  final int limit;

  const GetAllStudentsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class GetStudentByIdEvent extends StudentEvent {
  final int id;

  const GetStudentByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateStudentEvent extends StudentEvent {
  final Map<String, dynamic> data;

  const CreateStudentEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateStudentEvent extends StudentEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateStudentEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteStudentEvent extends StudentEvent {
  final int id;

  const DeleteStudentEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchStudentsEvent extends StudentEvent {
  final String query;

  const SearchStudentsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class GetStudentPerformanceEvent extends StudentEvent {
  final int studentId;

  const GetStudentPerformanceEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class GetStudentResultsEvent extends StudentEvent {
  final int studentId;

  const GetStudentResultsEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class GetStudentAttendanceEvent extends StudentEvent {
  final int studentId;

  const GetStudentAttendanceEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
