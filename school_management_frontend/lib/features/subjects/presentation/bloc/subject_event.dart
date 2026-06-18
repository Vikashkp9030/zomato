import 'package:equatable/equatable.dart';

abstract class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object?> get props => [];
}

class GetAllSubjectsEvent extends SubjectEvent {
  final int page;
  final int limit;

  const GetAllSubjectsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class GetSubjectByIdEvent extends SubjectEvent {
  final int id;

  const GetSubjectByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateSubjectEvent extends SubjectEvent {
  final Map<String, dynamic> data;

  const CreateSubjectEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateSubjectEvent extends SubjectEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateSubjectEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteSubjectEvent extends SubjectEvent {
  final int id;

  const DeleteSubjectEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchSubjectsEvent extends SubjectEvent {
  final String query;

  const SearchSubjectsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class GetSubjectTeachersEvent extends SubjectEvent {
  final int subjectId;

  const GetSubjectTeachersEvent(this.subjectId);

  @override
  List<Object?> get props => [subjectId];
}

class GetSubjectClassesEvent extends SubjectEvent {
  final int subjectId;

  const GetSubjectClassesEvent(this.subjectId);

  @override
  List<Object?> get props => [subjectId];
}
