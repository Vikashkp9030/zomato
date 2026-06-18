import 'package:equatable/equatable.dart';
import '../../domain/entities/parent_entity.dart';
import '../../../students/domain/entities/student_entity.dart';

abstract class ParentState extends Equatable {
  const ParentState();

  @override
  List<Object?> get props => [];
}

class ParentInitial extends ParentState {
  const ParentInitial();
}

class ParentLoading extends ParentState {
  const ParentLoading();
}

class ParentsLoaded extends ParentState {
  final List<ParentEntity> parents;

  const ParentsLoaded({required this.parents});

  @override
  List<Object?> get props => [parents];
}

class ParentLoaded extends ParentState {
  final ParentEntity parent;

  const ParentLoaded({required this.parent});

  @override
  List<Object?> get props => [parent];
}

class ParentCreated extends ParentState {
  final ParentEntity parent;

  const ParentCreated({required this.parent});

  @override
  List<Object?> get props => [parent];
}

class ParentUpdated extends ParentState {
  final ParentEntity parent;

  const ParentUpdated({required this.parent});

  @override
  List<Object?> get props => [parent];
}

class ParentDeleted extends ParentState {
  const ParentDeleted();
}

class ParentError extends ParentState {
  final String message;

  const ParentError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ParentChildrenLoaded extends ParentState {
  final List<StudentEntity> children;

  const ParentChildrenLoaded({required this.children});

  @override
  List<Object?> get props => [children];
}

class ParentStudentLinked extends ParentState {
  const ParentStudentLinked();
}

class ParentStudentUnlinked extends ParentState {
  const ParentStudentUnlinked();
}

class ParentsSearchLoaded extends ParentState {
  final List<ParentEntity> parents;

  const ParentsSearchLoaded({required this.parents});

  @override
  List<Object?> get props => [parents];
}
