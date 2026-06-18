import 'package:equatable/equatable.dart';

class ExamStatsEntity extends Equatable {
  final int examId;
  final int totalStudents;
  final int passedStudents;
  final int failedStudents;
  final double averageMarks;
  final double highestMarks;
  final double lowestMarks;

  const ExamStatsEntity({
    required this.examId,
    required this.totalStudents,
    required this.passedStudents,
    required this.failedStudents,
    required this.averageMarks,
    required this.highestMarks,
    required this.lowestMarks,
  });

  @override
  List<Object?> get props => [
    examId,
    totalStudents,
    passedStudents,
    failedStudents,
    averageMarks,
    highestMarks,
    lowestMarks,
  ];
}
