import 'package:equatable/equatable.dart';

class ExamEntity extends Equatable {
  final int id;
  final String examName;
  final String examType;
  final DateTime examDate;
  final String examTime;
  final int totalMarks;
  final int passingMarks;
  final int subjectId;
  final int classId;

  const ExamEntity({
    required this.id,
    required this.examName,
    required this.examType,
    required this.examDate,
    required this.examTime,
    required this.totalMarks,
    required this.passingMarks,
    required this.subjectId,
    required this.classId,
  });

  @override
  List<Object?> get props => [
    id,
    examName,
    examType,
    examDate,
    examTime,
    totalMarks,
    passingMarks,
    subjectId,
    classId,
  ];
}
