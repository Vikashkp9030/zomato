import 'package:equatable/equatable.dart';

class ExamResultModel extends Equatable {
  final int id;
  final int examId;
  final int studentId;
  final double marksObtained;
  final String grade;
  final String status;
  final int attempt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ExamResultModel({
    required this.id,
    required this.examId,
    required this.studentId,
    required this.marksObtained,
    required this.grade,
    required this.status,
    required this.attempt,
    required this.createdAt,
    this.updatedAt,
  });

  double get percentage => (marksObtained / 100) * 100;

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      id: json['id'] as int,
      examId: json['exam_id'] as int,
      studentId: json['student_id'] as int,
      marksObtained: (json['marks_obtained'] as num).toDouble(),
      grade: json['grade'] as String,
      status: json['status'] as String,
      attempt: json['attempt'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exam_id': examId,
    'student_id': studentId,
    'marks_obtained': marksObtained,
    'grade': grade,
    'status': status,
    'attempt': attempt,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    examId,
    studentId,
    marksObtained,
    grade,
    status,
    attempt,
    createdAt,
    updatedAt,
  ];
}

class ExamResultRequest extends Equatable {
  final int examId;
  final int studentId;
  final double marksObtained;
  final String grade;
  final String status;
  final int attempt;

  const ExamResultRequest({
    required this.examId,
    required this.studentId,
    required this.marksObtained,
    required this.grade,
    required this.status,
    required this.attempt,
  });

  Map<String, dynamic> toJson() => {
    'exam_id': examId,
    'student_id': studentId,
    'marks_obtained': marksObtained,
    'grade': grade,
    'status': status,
    'attempt': attempt,
  };

  @override
  List<Object?> get props => [
    examId,
    studentId,
    marksObtained,
    grade,
    status,
    attempt,
  ];
}

class ExamStatsModel extends Equatable {
  final int examId;
  final int totalStudents;
  final int passedStudents;
  final int failedStudents;
  final double averageMarks;
  final double highestMarks;
  final double lowestMarks;
  final String gradeDistribution;

  const ExamStatsModel({
    required this.examId,
    required this.totalStudents,
    required this.passedStudents,
    required this.failedStudents,
    required this.averageMarks,
    required this.highestMarks,
    required this.lowestMarks,
    required this.gradeDistribution,
  });

  factory ExamStatsModel.fromJson(Map<String, dynamic> json) {
    return ExamStatsModel(
      examId: json['exam_id'] as int,
      totalStudents: json['total_students'] as int,
      passedStudents: json['passed_students'] as int,
      failedStudents: json['failed_students'] as int,
      averageMarks: (json['average_marks'] as num).toDouble(),
      highestMarks: (json['highest_marks'] as num).toDouble(),
      lowestMarks: (json['lowest_marks'] as num).toDouble(),
      gradeDistribution: json['grade_distribution'] as String,
    );
  }

  @override
  List<Object?> get props => [
    examId,
    totalStudents,
    passedStudents,
    failedStudents,
    averageMarks,
    highestMarks,
    lowestMarks,
    gradeDistribution,
  ];
}
