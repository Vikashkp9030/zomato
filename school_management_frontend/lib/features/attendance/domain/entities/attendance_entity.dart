import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final int id;
  final int studentId;
  final int classId;
  final DateTime attendanceDate;
  final String status;
  final String? remarks;

  const AttendanceEntity({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.attendanceDate,
    required this.status,
    this.remarks,
  });

  bool get isPresent => status.toLowerCase() == 'present';
  bool get isAbsent => status.toLowerCase() == 'absent';
  bool get isLeave => status.toLowerCase() == 'leave';

  @override
  List<Object?> get props => [
    id,
    studentId,
    classId,
    attendanceDate,
    status,
    remarks,
  ];
}
