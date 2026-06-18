import 'package:equatable/equatable.dart';
import '../../domain/entities/class_entity.dart';
import '../../../students/domain/entities/student_entity.dart';
import '../../../subjects/domain/entities/subject_entity.dart';

abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object?> get props => [];
}

class ClassInitial extends ClassState {
  const ClassInitial();
}

class ClassLoading extends ClassState {
  const ClassLoading();
}

class ClassesLoaded extends ClassState {
  final List<ClassEntity> classes;
  final int page;
  final int limit;

  const ClassesLoaded({
    required this.classes,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [classes, page, limit];
}

class ClassLoaded extends ClassState {
  final ClassEntity classEntity;

  const ClassLoaded({required this.classEntity});

  @override
  List<Object?> get props => [classEntity];
}

class ClassStudentsLoaded extends ClassState {
  final List<StudentEntity> students;

  const ClassStudentsLoaded({required this.students});

  @override
  List<Object?> get props => [students];
}

class ClassSubjectsLoaded extends ClassState {
  final List<SubjectEntity> subjects;

  const ClassSubjectsLoaded({required this.subjects});

  @override
  List<Object?> get props => [subjects];
}

class ClassSuccess extends ClassState {
  final String message;

  const ClassSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ClassError extends ClassState {
  final String message;

  const ClassError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ClassCreated extends ClassState {
  final ClassEntity classEntity;

  const ClassCreated({required this.classEntity});

  @override
  List<Object?> get props => [classEntity];
}

class ClassUpdated extends ClassState {
  final ClassEntity classEntity;

  const ClassUpdated({required this.classEntity});

  @override
  List<Object?> get props => [classEntity];
}

class ClassDeleted extends ClassState {
  const ClassDeleted();
}
