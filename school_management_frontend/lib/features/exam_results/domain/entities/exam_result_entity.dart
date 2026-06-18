import 'package:equatable/equatable.dart';

class ExamResultEntity extends Equatable {
  final int id;
  final int examId;
  final int studentId;
  final double marksObtained;
  final String grade;
  final String status;
  final int attempt;

  const ExamResultEntity({
    required this.id,
    required this.examId,
    required this.studentId,
    required this.marksObtained,
    required this.grade,
    required this.status,
    required this.attempt,
  });

  double get percentage => (marksObtained / 100) * 100;

  @override
  List<Object?> get props => [
    id,
    examId,
    studentId,
    marksObtained,
    grade,
    status,
    attempt,
  ];
}
