import 'package:equatable/equatable.dart';
import '../../domain/entities/exam_result_entity.dart';
import '../../domain/entities/exam_stats_entity.dart';

abstract class ExamResultState extends Equatable {
  const ExamResultState();

  @override
  List<Object?> get props => [];
}

class ExamResultInitial extends ExamResultState {
  const ExamResultInitial();
}

class ExamResultLoading extends ExamResultState {
  const ExamResultLoading();
}

class ExamResultsLoaded extends ExamResultState {
  final List<dynamic> results;

  const ExamResultsLoaded({required this.results});

  @override
  List<Object?> get props => [results];
}

class ExamResultLoaded extends ExamResultState {
  final ExamResultEntity result;

  const ExamResultLoaded({required this.result});

  @override
  List<Object?> get props => [result];
}

class ExamResultCreated extends ExamResultState {
  final ExamResultEntity result;

  const ExamResultCreated({required this.result});

  @override
  List<Object?> get props => [result];
}

class ExamResultUpdated extends ExamResultState {
  final ExamResultEntity result;

  const ExamResultUpdated({required this.result});

  @override
  List<Object?> get props => [result];
}

class ExamResultDeleted extends ExamResultState {
  const ExamResultDeleted();
}

class ExamResultError extends ExamResultState {
  final String message;

  const ExamResultError({required this.message});

  @override
  List<Object?> get props => [message];
}

class StudentResultsLoaded extends ExamResultState {
  final List<ExamResultEntity> results;

  const StudentResultsLoaded({required this.results});

  @override
  List<Object?> get props => [results];
}

class ClassResultsLoaded extends ExamResultState {
  final List<ExamResultEntity> results;

  const ClassResultsLoaded({required this.results});

  @override
  List<Object?> get props => [results];
}

class ExamStatisticsLoaded extends ExamResultState {
  final ExamStatsEntity statistics;

  const ExamStatisticsLoaded({required this.statistics});

  @override
  List<Object?> get props => [statistics];
}

class ExamResultsSearchLoaded extends ExamResultState {
  final List<dynamic> results;

  const ExamResultsSearchLoaded({required this.results});

  @override
  List<Object?> get props => [results];
}
