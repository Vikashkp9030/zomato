import 'package:equatable/equatable.dart';

class ParentModel extends Equatable {
  final int id;
  final int studentId;
  final String parentName;
  final String relationship;
  final String phone;
  final String email;
  final String? occupation;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ParentModel({
    required this.id,
    required this.studentId,
    required this.parentName,
    required this.relationship,
    required this.phone,
    required this.email,
    this.occupation,
    required this.createdAt,
    this.updatedAt,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      parentName: json['parent_name'] as String,
      relationship: json['relationship'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      occupation: json['occupation'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': studentId,
    'parent_name': parentName,
    'relationship': relationship,
    'phone': phone,
    'email': email,
    'occupation': occupation,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    studentId,
    parentName,
    relationship,
    phone,
    email,
    occupation,
    createdAt,
    updatedAt,
  ];
}

class ParentRequest extends Equatable {
  final int studentId;
  final String parentName;
  final String relationship;
  final String phone;
  final String email;
  final String? occupation;

  const ParentRequest({
    required this.studentId,
    required this.parentName,
    required this.relationship,
    required this.phone,
    required this.email,
    this.occupation,
  });

  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'parent_name': parentName,
    'relationship': relationship,
    'phone': phone,
    'email': email,
    'occupation': occupation,
  };

  @override
  List<Object?> get props => [
    studentId,
    parentName,
    relationship,
    phone,
    email,
    occupation,
  ];
}
