import 'package:equatable/equatable.dart';

class StudentModel extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String gender;
  final int classId;
  final DateTime enrollmentDate;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.classId,
    required this.enrollmentDate,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String,
      classId: json['class_id'] as int,
      enrollmentDate: DateTime.parse(json['enrollment_date'] as String),
      status: json['status'] as String,
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
    'date_of_birth': dateOfBirth.toIso8601String(),
    'gender': gender,
    'class_id': classId,
    'enrollment_date': enrollmentDate.toIso8601String(),
    'status': status,
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
    dateOfBirth,
    gender,
    classId,
    enrollmentDate,
    status,
    createdAt,
    updatedAt,
  ];
}

class StudentRequest extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String gender;
  final int classId;
  final DateTime enrollmentDate;

  const StudentRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.classId,
    required this.enrollmentDate,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'gender': gender,
    'class_id': classId,
    'enrollment_date': enrollmentDate.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    dateOfBirth,
    gender,
    classId,
    enrollmentDate,
  ];
}

class StudentPerformanceModel extends Equatable {
  final int studentId;
  final String studentName;
  final double gpa;
  final double averageMarks;
  final int totalExams;
  final int passedExams;
  final int failedExams;
  final double attendancePercentage;

  const StudentPerformanceModel({
    required this.studentId,
    required this.studentName,
    required this.gpa,
    required this.averageMarks,
    required this.totalExams,
    required this.passedExams,
    required this.failedExams,
    required this.attendancePercentage,
  });

  factory StudentPerformanceModel.fromJson(Map<String, dynamic> json) {
    return StudentPerformanceModel(
      studentId: json['student_id'] as int,
      studentName: json['student_name'] as String,
      gpa: (json['gpa'] as num).toDouble(),
      averageMarks: (json['average_marks'] as num).toDouble(),
      totalExams: json['total_exams'] as int,
      passedExams: json['passed_exams'] as int,
      failedExams: json['failed_exams'] as int,
      attendancePercentage: (json['attendance_percentage'] as num).toDouble(),
    );
  }

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
