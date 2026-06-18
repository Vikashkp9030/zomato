import 'package:equatable/equatable.dart';

class ClassModel extends Equatable {
  final int id;
  final String className;
  final int gradeLevel;
  final String section;
  final int capacity;
  final int classTeacherId;
  final String roomNumber;
  final int currentStudents;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ClassModel({
    required this.id,
    required this.className,
    required this.gradeLevel,
    required this.section,
    required this.capacity,
    required this.classTeacherId,
    required this.roomNumber,
    required this.currentStudents,
    required this.createdAt,
    this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as int,
      className: json['class_name'] as String,
      gradeLevel: json['grade_level'] as int,
      section: json['section'] as String,
      capacity: json['capacity'] as int,
      classTeacherId: json['class_teacher_id'] as int,
      roomNumber: json['room_number'] as String,
      currentStudents: json['current_students'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'class_name': className,
    'grade_level': gradeLevel,
    'section': section,
    'capacity': capacity,
    'class_teacher_id': classTeacherId,
    'room_number': roomNumber,
    'current_students': currentStudents,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

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
    createdAt,
    updatedAt,
  ];
}

class ClassRequest extends Equatable {
  final String className;
  final int gradeLevel;
  final String section;
  final int capacity;
  final int classTeacherId;
  final String roomNumber;

  const ClassRequest({
    required this.className,
    required this.gradeLevel,
    required this.section,
    required this.capacity,
    required this.classTeacherId,
    required this.roomNumber,
  });

  Map<String, dynamic> toJson() => {
    'class_name': className,
    'grade_level': gradeLevel,
    'section': section,
    'capacity': capacity,
    'class_teacher_id': classTeacherId,
    'room_number': roomNumber,
  };

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

class ClassInfoModel extends Equatable {
  final int id;
  final String className;
  final int gradeLevel;
  final String section;
  final int capacity;
  final int currentStudents;
  final int vacantSeats;
  final String occupancyPercentage;
  final int totalSubjects;
  final String classTeacherName;

  const ClassInfoModel({
    required this.id,
    required this.className,
    required this.gradeLevel,
    required this.section,
    required this.capacity,
    required this.currentStudents,
    required this.vacantSeats,
    required this.occupancyPercentage,
    required this.totalSubjects,
    required this.classTeacherName,
  });

  factory ClassInfoModel.fromJson(Map<String, dynamic> json) {
    return ClassInfoModel(
      id: json['id'] as int,
      className: json['class_name'] as String,
      gradeLevel: json['grade_level'] as int,
      section: json['section'] as String,
      capacity: json['capacity'] as int,
      currentStudents: json['current_students'] as int,
      vacantSeats: json['vacant_seats'] as int,
      occupancyPercentage: json['occupancy_percentage'] as String,
      totalSubjects: json['total_subjects'] as int,
      classTeacherName: json['class_teacher_name'] as String,
    );
  }

  @override
  List<Object?> get props => [
    id,
    className,
    gradeLevel,
    section,
    capacity,
    currentStudents,
    vacantSeats,
    occupancyPercentage,
    totalSubjects,
    classTeacherName,
  ];
}
