import 'package:equatable/equatable.dart';

class ExamModel extends Equatable {
  final int id;
  final String examName;
  final String examType;
  final DateTime examDate;
  final String examTime;
  final int totalMarks;
  final int passingMarks;
  final int subjectId;
  final int classId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ExamModel({
    required this.id,
    required this.examName,
    required this.examType,
    required this.examDate,
    required this.examTime,
    required this.totalMarks,
    required this.passingMarks,
    required this.subjectId,
    required this.classId,
    required this.createdAt,
    this.updatedAt,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as int,
      examName: json['exam_name'] as String,
      examType: json['exam_type'] as String,
      examDate: DateTime.parse(json['exam_date'] as String),
      examTime: json['exam_time'] as String,
      totalMarks: json['total_marks'] as int,
      passingMarks: json['passing_marks'] as int,
      subjectId: json['subject_id'] as int,
      classId: json['class_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exam_name': examName,
    'exam_type': examType,
    'exam_date': examDate.toIso8601String(),
    'exam_time': examTime,
    'total_marks': totalMarks,
    'passing_marks': passingMarks,
    'subject_id': subjectId,
    'class_id': classId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

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
    createdAt,
    updatedAt,
  ];
}

class ExamRequest extends Equatable {
  final String examName;
  final String examType;
  final DateTime examDate;
  final String examTime;
  final int totalMarks;
  final int passingMarks;
  final int subjectId;
  final int classId;

  const ExamRequest({
    required this.examName,
    required this.examType,
    required this.examDate,
    required this.examTime,
    required this.totalMarks,
    required this.passingMarks,
    required this.subjectId,
    required this.classId,
  });

  Map<String, dynamic> toJson() => {
    'exam_name': examName,
    'exam_type': examType,
    'exam_date': examDate.toIso8601String(),
    'exam_time': examTime,
    'total_marks': totalMarks,
    'passing_marks': passingMarks,
    'subject_id': subjectId,
    'class_id': classId,
  };

  @override
  List<Object?> get props => [
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
