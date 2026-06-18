import 'package:equatable/equatable.dart';

class AttendanceModel extends Equatable {
  final int id;
  final int studentId;
  final int classId;
  final DateTime attendanceDate;
  final String status;
  final String? remarks;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AttendanceModel({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.attendanceDate,
    required this.status,
    this.remarks,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isPresent => status.toLowerCase() == 'present';
  bool get isAbsent => status.toLowerCase() == 'absent';
  bool get isLeave => status.toLowerCase() == 'leave';

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      classId: json['class_id'] as int,
      attendanceDate: DateTime.parse(json['attendance_date'] as String),
      status: json['status'] as String,
      remarks: json['remarks'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': studentId,
    'class_id': classId,
    'attendance_date': attendanceDate.toIso8601String(),
    'status': status,
    'remarks': remarks,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    studentId,
    classId,
    attendanceDate,
    status,
    remarks,
    createdAt,
    updatedAt,
  ];
}

class AttendanceRequest extends Equatable {
  final int studentId;
  final int classId;
  final DateTime attendanceDate;
  final String status;
  final String? remarks;

  const AttendanceRequest({
    required this.studentId,
    required this.classId,
    required this.attendanceDate,
    required this.status,
    this.remarks,
  });

  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'class_id': classId,
    'attendance_date': attendanceDate.toIso8601String(),
    'status': status,
    'remarks': remarks,
  };

  @override
  List<Object?> get props => [
    studentId,
    classId,
    attendanceDate,
    status,
    remarks,
  ];
}

class AttendanceSummaryModel extends Equatable {
  final int studentId;
  final int totalDays;
  final int presentDays;
  final int absentDays;
  final int leaveDays;
  final double attendancePercentage;
  final DateTime fromDate;
  final DateTime toDate;

  const AttendanceSummaryModel({
    required this.studentId,
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.leaveDays,
    required this.attendancePercentage,
    required this.fromDate,
    required this.toDate,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      studentId: json['student_id'] as int,
      totalDays: json['total_days'] as int,
      presentDays: json['present_days'] as int,
      absentDays: json['absent_days'] as int,
      leaveDays: json['leave_days'] as int,
      attendancePercentage: (json['attendance_percentage'] as num).toDouble(),
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
    );
  }

  @override
  List<Object?> get props => [
    studentId,
    totalDays,
    presentDays,
    absentDays,
    leaveDays,
    attendancePercentage,
    fromDate,
    toDate,
  ];
}
