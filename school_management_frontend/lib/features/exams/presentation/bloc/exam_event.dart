import 'package:equatable/equatable.dart';

abstract class ExamEvent extends Equatable {
  const ExamEvent();

  @override
  List<Object?> get props => [];
}

class GetAllExamsEvent extends ExamEvent {
  final int page;
  final int limit;

  const GetAllExamsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class GetExamByIdEvent extends ExamEvent {
  final int id;

  const GetExamByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateExamEvent extends ExamEvent {
  final Map<String, dynamic> data;

  const CreateExamEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateExamEvent extends ExamEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateExamEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteExamEvent extends ExamEvent {
  final int id;

  const DeleteExamEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetUpcomingExamsEvent extends ExamEvent {
  const GetUpcomingExamsEvent();
}

class GetExamsByClassEvent extends ExamEvent {
  final int classId;

  const GetExamsByClassEvent(this.classId);

  @override
  List<Object?> get props => [classId];
}

class GetExamResultsEvent extends ExamEvent {
  final int examId;

  const GetExamResultsEvent(this.examId);

  @override
  List<Object?> get props => [examId];
}

class SearchExamsEvent extends ExamEvent {
  final String query;

  const SearchExamsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
