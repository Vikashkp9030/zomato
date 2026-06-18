import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String gender;
  final int classId;
  final String status;

  const StudentEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.classId,
    required this.status,
  });

  String get fullName => '$firstName $lastName';

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
    status,
  ];
}
