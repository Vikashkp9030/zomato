import 'package:equatable/equatable.dart';

class TeacherModel extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String specialization;
  final double salary;
  final int experienceYears;
  final DateTime hireDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TeacherModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.salary,
    required this.experienceYears,
    required this.hireDate,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      specialization: json['specialization'] as String,
      salary: (json['salary'] as num).toDouble(),
      experienceYears: json['experience_years'] as int,
      hireDate: DateTime.parse(json['hire_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'specialization': specialization,
    'salary': salary,
    'experience_years': experienceYears,
    'hire_date': hireDate.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phone,
    specialization,
    salary,
    experienceYears,
    hireDate,
    createdAt,
    updatedAt,
  ];
}

class TeacherRequest extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String specialization;
  final double salary;
  final int experienceYears;
  final DateTime hireDate;

  const TeacherRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.salary,
    required this.experienceYears,
    required this.hireDate,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'specialization': specialization,
    'salary': salary,
    'experience_years': experienceYears,
    'hire_date': hireDate.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    specialization,
    salary,
    experienceYears,
    hireDate,
  ];
}
