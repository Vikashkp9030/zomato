import 'package:equatable/equatable.dart';

class ClassEntity extends Equatable {
  final int id;
  final String className;
  final int gradeLevel;
  final String section;
  final int capacity;
  final int classTeacherId;
  final String roomNumber;
  final int currentStudents;

  const ClassEntity({
    required this.id,
    required this.className,
    required this.gradeLevel,
    required this.section,
    required this.capacity,
    required this.classTeacherId,
    required this.roomNumber,
    required this.currentStudents,
  });

  @override
  List<Object?> get props => [
    id,
    className,
    gradeLevel,
    section,
    capacity,
    classTeacherId,
    roomNumber,
    currentStudents,
  ];
}
