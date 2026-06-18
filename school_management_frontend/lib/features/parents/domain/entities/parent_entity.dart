import 'package:equatable/equatable.dart';

class ParentEntity extends Equatable {
  final int id;
  final int studentId;
  final String parentName;
  final String relationship;
  final String phone;
  final String email;
  final String? occupation;

  const ParentEntity({
    required this.id,
    required this.studentId,
    required this.parentName,
    required this.relationship,
    required this.phone,
    required this.email,
    this.occupation,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    parentName,
    relationship,
    phone,
    email,
    occupation,
  ];
}
