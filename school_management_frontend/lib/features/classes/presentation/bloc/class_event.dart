import 'package:equatable/equatable.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object?> get props => [];
}

class GetAllClassesEvent extends ClassEvent {
  final int page;
  final int limit;

  const GetAllClassesEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class GetClassByIdEvent extends ClassEvent {
  final int id;

  const GetClassByIdEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class CreateClassEvent extends ClassEvent {
  final String className;
  final int gradeLevel;
  final String section;
  final int capacity;
  final int classTeacherId;
  final String roomNumber;

  const CreateClassEvent({
    required this.className,
    required this.gradeLevel,
    required this.section,
    required this.capacity,
    required this.classTeacherId,
    required this.roomNumber,
  });

  @override
  List<Object?> get props => [
    className,
    gradeLevel,
    section,
    capacity,
    classTeacherId,
    roomNumber,
  ];
}

class UpdateClassEvent extends ClassEvent {
  final int id;
  final String className;
  final int gradeLevel;
  final String section;
  final int capacity;
  final int classTeacherId;
  final String roomNumber;

  const UpdateClassEvent({
    required this.id,
    required this.className,
    required this.gradeLevel,
    required this.section,
    required this.capacity,
    required this.classTeacherId,
    required this.roomNumber,
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
  ];
}

class DeleteClassEvent extends ClassEvent {
  final int id;

  const DeleteClassEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetClassStudentsEvent extends ClassEvent {
  final int classId;

  const GetClassStudentsEvent({required this.classId});

  @override
  List<Object?> get props => [classId];
}

class GetClassSubjectsEvent extends ClassEvent {
  final int classId;

  const GetClassSubjectsEvent({required this.classId});

  @override
  List<Object?> get props => [classId];
}
