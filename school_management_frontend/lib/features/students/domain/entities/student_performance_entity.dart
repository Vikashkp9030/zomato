import 'package:equatable/equatable.dart';

class StudentPerformanceEntity extends Equatable {
  final int studentId;
  final String studentName;
  final double gpa;
  final double averageMarks;
  final int totalExams;
  final int passedExams;
  final int failedExams;
  final double attendancePercentage;

  const StudentPerformanceEntity({
    required this.studentId,
    required this.studentName,
    required this.gpa,
    required this.averageMarks,
    required this.totalExams,
    required this.passedExams,
    required this.failedExams,
    required this.attendancePercentage,
  });

  @override
  List<Object?> get props => [
    studentId,
    studentName,
    gpa,
    averageMarks,
    totalExams,
    passedExams,
    failedExams,
    attendancePercentage,
  ];
}
