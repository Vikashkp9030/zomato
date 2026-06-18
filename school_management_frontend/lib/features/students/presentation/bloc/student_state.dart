import 'package:equatable/equatable.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/entities/student_performance_entity.dart';
import '../../../exam_results/domain/entities/exam_result_entity.dart';
import '../../../attendance/domain/entities/attendance_summary_entity.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {
  const StudentInitial();
}

class StudentLoading extends StudentState {
  const StudentLoading();
}

class StudentsLoaded extends StudentState {
  final List<StudentEntity> students;

  const StudentsLoaded({required this.students});

  @override
  List<Object?> get props => [students];
}

class StudentLoaded extends StudentState {
  final StudentEntity student;

  const StudentLoaded({required this.student});

  @override
  List<Object?> get props => [student];
}

class StudentCreated extends StudentState {
  final StudentEntity student;

  const StudentCreated({required this.student});

  @override
  List<Object?> get props => [student];
}

class StudentUpdated extends StudentState {
  final StudentEntity student;

  const StudentUpdated({required this.student});

  @override
  List<Object?> get props => [student];
}

class StudentDeleted extends StudentState {
  const StudentDeleted();
}

class StudentError extends StudentState {
  final String message;

  const StudentError({required this.message});

  @override
  List<Object?> get props => [message];
}

class StudentPerformanceLoaded extends StudentState {
  final StudentPerformanceEntity performance;

  const StudentPerformanceLoaded({required this.performance});

  @override
  List<Object?> get props => [performance];
}

class StudentResultsLoaded extends StudentState {
  final List<ExamResultEntity> results;

  const StudentResultsLoaded({required this.results});

  @override
  List<Object?> get props => [results];
}

class StudentAttendanceLoaded extends StudentState {
  final AttendanceSummaryEntity attendance;

  const StudentAttendanceLoaded({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

class StudentsSearchLoaded extends StudentState {
  final List<StudentEntity> students;

  const StudentsSearchLoaded({required this.students});

  @override
  List<Object?> get props => [students];
}
