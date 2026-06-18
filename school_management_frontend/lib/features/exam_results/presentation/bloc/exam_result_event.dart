import 'package:equatable/equatable.dart';

abstract class ExamResultEvent extends Equatable {
  const ExamResultEvent();

  @override
  List<Object?> get props => [];
}

class GetAllResultsEvent extends ExamResultEvent {
  final int page;
  final int limit;

  const GetAllResultsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class GetResultByIdEvent extends ExamResultEvent {
  final int id;

  const GetResultByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateResultEvent extends ExamResultEvent {
  final Map<String, dynamic> data;

  const CreateResultEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateResultEvent extends ExamResultEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateResultEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteResultEvent extends ExamResultEvent {
  final int id;

  const DeleteResultEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetStudentResultsEvent extends ExamResultEvent {
  final int studentId;

  const GetStudentResultsEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class GetClassResultsEvent extends ExamResultEvent {
  final int classId;

  const GetClassResultsEvent(this.classId);

  @override
  List<Object?> get props => [classId];
}

class GetExamStatisticsEvent extends ExamResultEvent {
  final int examId;

  const GetExamStatisticsEvent(this.examId);

  @override
  List<Object?> get props => [examId];
}

class SearchResultsEvent extends ExamResultEvent {
  final String query;

  const SearchResultsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
