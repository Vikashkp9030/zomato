import 'package:equatable/equatable.dart';

class TeacherEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String specialization;
  final double salary;
  final int experienceYears;

  const TeacherEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.salary,
    required this.experienceYears,
  });

  String get fullName => '$firstName $lastName';

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
  ];
}
