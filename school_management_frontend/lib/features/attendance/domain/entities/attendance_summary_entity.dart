import 'package:equatable/equatable.dart';

class AttendanceSummaryEntity extends Equatable {
  final int studentId;
  final int totalDays;
  final int presentDays;
  final int absentDays;
  final int leaveDays;
  final double attendancePercentage;

  const AttendanceSummaryEntity({
    required this.studentId,
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.leaveDays,
    required this.attendancePercentage,
  });

  @override
  List<Object?> get props => [
    studentId,
    totalDays,
    presentDays,
    absentDays,
    leaveDays,
    attendancePercentage,
  ];
}
