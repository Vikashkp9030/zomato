import 'package:equatable/equatable.dart';
import '../../domain/entities/subject_entity.dart';
import '../../../teachers/domain/entities/teacher_entity.dart';
import '../../../classes/domain/entities/class_entity.dart';

abstract class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {
  const SubjectInitial();
}

class SubjectLoading extends SubjectState {
  const SubjectLoading();
}

class SubjectsLoaded extends SubjectState {
  final List<SubjectEntity> subjects;

  const SubjectsLoaded({required this.subjects});

  @override
  List<Object?> get props => [subjects];
}

class SubjectLoaded extends SubjectState {
  final SubjectEntity subject;

  const SubjectLoaded({required this.subject});

  @override
  List<Object?> get props => [subject];
}

class SubjectCreated extends SubjectState {
  final SubjectEntity subject;

  const SubjectCreated({required this.subject});

  @override
  List<Object?> get props => [subject];
}

class SubjectUpdated extends SubjectState {
  final SubjectEntity subject;

  const SubjectUpdated({required this.subject});

  @override
  List<Object?> get props => [subject];
}

class SubjectDeleted extends SubjectState {
  const SubjectDeleted();
}

class SubjectError extends SubjectState {
  final String message;

  const SubjectError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SubjectTeachersLoaded extends SubjectState {
  final List<TeacherEntity> teachers;

  const SubjectTeachersLoaded({required this.teachers});

  @override
  List<Object?> get props => [teachers];
}

class SubjectClassesLoaded extends SubjectState {
  final List<ClassEntity> classes;

  const SubjectClassesLoaded({required this.classes});

  @override
  List<Object?> get props => [classes];
}

class SubjectsSearchLoaded extends SubjectState {
  final List<SubjectEntity> subjects;

  const SubjectsSearchLoaded({required this.subjects});

  @override
  List<Object?> get props => [subjects];
}
