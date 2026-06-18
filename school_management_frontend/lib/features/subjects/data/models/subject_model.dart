import 'package:equatable/equatable.dart';

class SubjectModel extends Equatable {
  final int id;
  final String subjectName;
  final String subjectCode;
  final int credits;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SubjectModel({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.credits,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as int,
      subjectName: json['subject_name'] as String,
      subjectCode: json['subject_code'] as String,
      credits: json['credits'] as int,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_name': subjectName,
    'subject_code': subjectCode,
    'credits': credits,
    'description': description,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    subjectName,
    subjectCode,
    credits,
    description,
    createdAt,
    updatedAt,
  ];
}

class SubjectRequest extends Equatable {
  final String subjectName;
  final String subjectCode;
  final int credits;
  final String? description;

  const SubjectRequest({
    required this.subjectName,
    required this.subjectCode,
    required this.credits,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'subject_name': subjectName,
    'subject_code': subjectCode,
    'credits': credits,
    'description': description,
  };

  @override
  List<Object?> get props => [
    subjectName,
    subjectCode,
    credits,
    description,
  ];
}
