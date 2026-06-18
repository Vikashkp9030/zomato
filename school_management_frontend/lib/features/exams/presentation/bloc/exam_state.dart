import 'package:equatable/equatable.dart';
import '../../domain/entities/exam_entity.dart';
import '../../../exam_results/domain/entities/exam_result_entity.dart';

abstract class ExamState extends Equatable {
  const ExamState();

  @override
  List<Object?> get props => [];
}

class ExamInitial extends ExamState {
  const ExamInitial();
}

class ExamLoading extends ExamState {
  const ExamLoading();
}

class ExamsLoaded extends ExamState {
  final List<ExamEntity> exams;

  const ExamsLoaded({required this.exams});

  @override
  List<Object?> get props => [exams];
}

class ExamLoaded extends ExamState {
  final ExamEntity exam;

  const ExamLoaded({required this.exam});

  @override
  List<Object?> get props => [exam];
}

class ExamCreated extends ExamState {
  final ExamEntity exam;

  const ExamCreated({required this.exam});

  @override
  List<Object?> get props => [exam];
}

class ExamUpdated extends ExamState {
  final ExamEntity exam;

  const ExamUpdated({required this.exam});

  @override
  List<Object?> get props => [exam];
}

class ExamDeleted extends ExamState {
  const ExamDeleted();
}

class ExamError extends ExamState {
  final String message;

  const ExamError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpcomingExamsLoaded extends ExamState {
  final List<ExamEntity> exams;

  const UpcomingExamsLoaded({required this.exams});

  @override
  List<Object?> get props => [exams];
}

class ExamsByClassLoaded extends ExamState {
  final List<ExamEntity> exams;

  const ExamsByClassLoaded({required this.exams});

  @override
  List<Object?> get props => [exams];
}

class ExamResultsLoaded extends ExamState {
  final List<ExamResultEntity> results;

  const ExamResultsLoaded({required this.results});

  @override
  List<Object?> get props => [results];
}

class ExamsSearchLoaded extends ExamState {
  final List<ExamEntity> exams;

  const ExamsSearchLoaded({required this.exams});

  @override
  List<Object?> get props => [exams];
}
