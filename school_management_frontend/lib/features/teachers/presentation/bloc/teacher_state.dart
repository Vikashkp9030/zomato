import 'package:equatable/equatable.dart';
import '../../domain/entities/teacher_entity.dart';
import '../../../classes/domain/entities/class_entity.dart';
import '../../../subjects/domain/entities/subject_entity.dart';

abstract class TeacherState extends Equatable {
  const TeacherState();
  List<Object?> get props => [];
}

class TeacherInitial extends TeacherState {
  const TeacherInitial();
}

class TeacherLoading extends TeacherState {
  const TeacherLoading();
}

class TeachersLoaded extends TeacherState {
  final List<TeacherEntity> teachers;
  final int page;
  final int limit;
  const TeachersLoaded({required this.teachers, required this.page, required this.limit});
  List<Object?> get props => [teachers, page, limit];
}

class TeacherLoaded extends TeacherState {
  final TeacherEntity teacher;
  const TeacherLoaded({required this.teacher});
  List<Object?> get props => [teacher];
}

class TeacherClassesLoaded extends TeacherState {
  final List<ClassEntity> classes;
  const TeacherClassesLoaded({required this.classes});
  List<Object?> get props => [classes];
}

class TeacherSubjectsLoaded extends TeacherState {
  final List<SubjectEntity> subjects;
  const TeacherSubjectsLoaded({required this.subjects});
  List<Object?> get props => [subjects];
}

class TeacherCreated extends TeacherState {
  final TeacherEntity teacher;
  const TeacherCreated({required this.teacher});
  List<Object?> get props => [teacher];
}

class TeacherUpdated extends TeacherState {
  final TeacherEntity teacher;
  const TeacherUpdated({required this.teacher});
  List<Object?> get props => [teacher];
}

class TeacherDeleted extends TeacherState {
  const TeacherDeleted();
}

class TeacherError extends TeacherState {
  final String message;
  const TeacherError({required this.message});
  List<Object?> get props => [message];
}
