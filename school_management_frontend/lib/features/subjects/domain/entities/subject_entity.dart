import 'package:equatable/equatable.dart';

class SubjectEntity extends Equatable {
  final int id;
  final String subjectName;
  final String subjectCode;
  final int credits;
  final String? description;

  const SubjectEntity({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.credits,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    subjectName,
    subjectCode,
    credits,
    description,
  ];
}
