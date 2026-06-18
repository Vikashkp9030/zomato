import 'package:equatable/equatable.dart';

abstract class ParentEvent extends Equatable {
  const ParentEvent();

  @override
  List<Object?> get props => [];
}

class GetAllParentsEvent extends ParentEvent {
  final int page;
  final int limit;

  const GetAllParentsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class GetParentByIdEvent extends ParentEvent {
  final int id;

  const GetParentByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateParentEvent extends ParentEvent {
  final Map<String, dynamic> data;

  const CreateParentEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateParentEvent extends ParentEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateParentEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteParentEvent extends ParentEvent {
  final int id;

  const DeleteParentEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetParentChildrenEvent extends ParentEvent {
  final int parentId;

  const GetParentChildrenEvent(this.parentId);

  @override
  List<Object?> get props => [parentId];
}

class LinkParentToStudentEvent extends ParentEvent {
  final int parentId;
  final int studentId;

  const LinkParentToStudentEvent(this.parentId, this.studentId);

  @override
  List<Object?> get props => [parentId, studentId];
}

class UnlinkParentFromStudentEvent extends ParentEvent {
  final int parentId;
  final int studentId;

  const UnlinkParentFromStudentEvent(this.parentId, this.studentId);

  @override
  List<Object?> get props => [parentId, studentId];
}

class SearchParentsEvent extends ParentEvent {
  final String query;

  const SearchParentsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
