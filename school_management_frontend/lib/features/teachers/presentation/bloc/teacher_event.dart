import 'package:equatable/equatable.dart';

abstract class TeacherEvent extends Equatable {
  const TeacherEvent();
  List<Object?> get props => [];
}

class GetAllTeachersEvent extends TeacherEvent {
  final int page;
  final int limit;
  const GetAllTeachersEvent({this.page = 1, this.limit = 10});
  List<Object?> get props => [page, limit];
}

class GetTeacherByIdEvent extends TeacherEvent {
  final int id;
  const GetTeacherByIdEvent({required this.id});
  List<Object?> get props => [id];
}

class CreateTeacherEvent extends TeacherEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String specialization;
  final double salary;
  final int experienceYears;
  final DateTime hireDate;

  const CreateTeacherEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.salary,
    required this.experienceYears,
    required this.hireDate,
  });

  List<Object?> get props => [firstName, lastName, email, phone, specialization, salary, experienceYears, hireDate];
}

class UpdateTeacherEvent extends TeacherEvent {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String specialization;
  final double salary;
  final int experienceYears;
  final DateTime hireDate;

  const UpdateTeacherEvent({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.salary,
    required this.experienceYears,
    required this.hireDate,
  });

  List<Object?> get props => [id, firstName, lastName, email, phone, specialization, salary, experienceYears, hireDate];
}

class DeleteTeacherEvent extends TeacherEvent {
  final int id;
  const DeleteTeacherEvent({required this.id});
  List<Object?> get props => [id];
}

class GetTeacherClassesEvent extends TeacherEvent {
  final int teacherId;
  const GetTeacherClassesEvent({required this.teacherId});
  List<Object?> get props => [teacherId];
}

class GetTeacherSubjectsEvent extends TeacherEvent {
  final int teacherId;
  const GetTeacherSubjectsEvent({required this.teacherId});
  List<Object?> get props => [teacherId];
}
