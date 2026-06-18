# BLoC Template Guide - How to Create Remaining 6 Features

This guide shows how to quickly create the remaining BLoCs for Subject, Student, Exam, ExamResult, Attendance, and Parent features.

## Pattern Overview

Each feature needs 3 files:
1. `feature_event.dart` - Define all events
2. `feature_state.dart` - Define all states
3. `feature_bloc.dart` - Handle events and emit states

## Complete Example: Subject Feature

### 1. lib/presentation/bloc/subject/subject_event.dart

```dart
import 'package:equatable/equatable.dart';

abstract class SubjectEvent extends Equatable {
  const SubjectEvent();
  @override
  List<Object?> get props => [];
}

class GetAllSubjectsEvent extends SubjectEvent {
  final int page;
  final int limit;
  const GetAllSubjectsEvent({this.page = 1, this.limit = 10});
  @override
  List<Object?> get props => [page, limit];
}

class GetSubjectByIdEvent extends SubjectEvent {
  final int id;
  const GetSubjectByIdEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class CreateSubjectEvent extends SubjectEvent {
  final String subjectName;
  final String subjectCode;
  final int credits;
  final String? description;

  const CreateSubjectEvent({
    required this.subjectName,
    required this.subjectCode,
    required this.credits,
    this.description,
  });

  @override
  List<Object?> get props => [subjectName, subjectCode, credits, description];
}

class UpdateSubjectEvent extends SubjectEvent {
  final int id;
  final String subjectName;
  final String subjectCode;
  final int credits;
  final String? description;

  const UpdateSubjectEvent({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.credits,
    this.description,
  });

  @override
  List<Object?> get props => [id, subjectName, subjectCode, credits, description];
}

class DeleteSubjectEvent extends SubjectEvent {
  final int id;
  const DeleteSubjectEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class GetSubjectTeachersEvent extends SubjectEvent {
  final int subjectId;
  const GetSubjectTeachersEvent({required this.subjectId});
  @override
  List<Object?> get props => [subjectId];
}

class GetSubjectClassesEvent extends SubjectEvent {
  final int subjectId;
  const GetSubjectClassesEvent({required this.subjectId});
  @override
  List<Object?> get props => [subjectId];
}
```

### 2. lib/presentation/bloc/subject/subject_state.dart

```dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/all_entities.dart';

abstract class SubjectState extends Equatable {
  const SubjectState();
  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {
  const SubjectInitial();
}

class SubjectLoading extends SubjectState {
  const SubjectLoading();
}

class SubjectsLoaded extends SubjectState {
  final List<SubjectEntity> subjects;
  final int page;
  final int limit;
  const SubjectsLoaded({
    required this.subjects,
    required this.page,
    required this.limit,
  });
  @override
  List<Object?> get props => [subjects, page, limit];
}

class SubjectLoaded extends SubjectState {
  final SubjectEntity subject;
  const SubjectLoaded({required this.subject});
  @override
  List<Object?> get props => [subject];
}

class SubjectTeachersLoaded extends SubjectState {
  final List<TeacherEntity> teachers;
  const SubjectTeachersLoaded({required this.teachers});
  @override
  List<Object?> get props => [teachers];
}

class SubjectClassesLoaded extends SubjectState {
  final List<ClassEntity> classes;
  const SubjectClassesLoaded({required this.classes});
  @override
  List<Object?> get props => [classes];
}

class SubjectCreated extends SubjectState {
  final SubjectEntity subject;
  const SubjectCreated({required this.subject});
  @override
  List<Object?> get props => [subject];
}

class SubjectUpdated extends SubjectState {
  final SubjectEntity subject;
  const SubjectUpdated({required this.subject});
  @override
  List<Object?> get props => [subject];
}

class SubjectDeleted extends SubjectState {
  const SubjectDeleted();
}

class SubjectError extends SubjectState {
  final String message;
  const SubjectError({required this.message});
  @override
  List<Object?> get props => [message];
}
```

### 3. lib/presentation/bloc/subject/subject_bloc.dart

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../domain/usecases/subject_usecases.dart';
import 'subject_event.dart';
import 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectUseCases subjectUseCases;
  final Logger _logger = Logger();

  SubjectBloc(this.subjectUseCases) : super(const SubjectInitial()) {
    on<GetAllSubjectsEvent>(_onGetAllSubjects);
    on<GetSubjectByIdEvent>(_onGetSubjectById);
    on<CreateSubjectEvent>(_onCreateSubject);
    on<UpdateSubjectEvent>(_onUpdateSubject);
    on<DeleteSubjectEvent>(_onDeleteSubject);
    on<GetSubjectTeachersEvent>(_onGetSubjectTeachers);
    on<GetSubjectClassesEvent>(_onGetSubjectClasses);
  }

  Future<void> _onGetAllSubjects(
    GetAllSubjectsEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await subjectUseCases.getAllSubjects(page: event.page, limit: event.limit);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (subjects) => emit(SubjectsLoaded(subjects: subjects, page: event.page, limit: event.limit)),
    );
  }

  Future<void> _onGetSubjectById(
    GetSubjectByIdEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await subjectUseCases.getSubjectById(event.id);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (subject) => emit(SubjectLoaded(subject: subject)),
    );
  }

  Future<void> _onCreateSubject(
    CreateSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final data = {
      'subject_name': event.subjectName,
      'subject_code': event.subjectCode,
      'credits': event.credits,
      'description': event.description,
    };
    final result = await subjectUseCases.createSubject(data);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (subject) {
        _logger.i('Subject created: ${subject.subjectName}');
        emit(SubjectCreated(subject: subject));
      },
    );
  }

  Future<void> _onUpdateSubject(
    UpdateSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final data = {
      'subject_name': event.subjectName,
      'subject_code': event.subjectCode,
      'credits': event.credits,
      'description': event.description,
    };
    final result = await subjectUseCases.updateSubject(event.id, data);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (subject) {
        _logger.i('Subject updated: ${subject.subjectName}');
        emit(SubjectUpdated(subject: subject));
      },
    );
  }

  Future<void> _onDeleteSubject(
    DeleteSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await subjectUseCases.deleteSubject(event.id);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (_) {
        _logger.i('Subject deleted: ${event.id}');
        emit(const SubjectDeleted());
      },
    );
  }

  Future<void> _onGetSubjectTeachers(
    GetSubjectTeachersEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await subjectUseCases.getSubjectTeachers(event.subjectId);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (teachers) => emit(SubjectTeachersLoaded(teachers: teachers)),
    );
  }

  Future<void> _onGetSubjectClasses(
    GetSubjectClassesEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await subjectUseCases.getSubjectClasses(event.subjectId);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (classes) => emit(SubjectClassesLoaded(classes: classes)),
    );
  }
}
```

## Quick Implementation Steps

1. **Copy the Subject example above** and adapt for each feature
2. **Replace "Subject" with feature name** in:
   - Class names (SubjectEvent → StudentEvent, etc.)
   - File paths (subject_event.dart → student_event.dart, etc.)
3. **Update event properties** based on feature entity fields:
   - Student: firstName, lastName, email, phone, dateOfBirth, gender, classId
   - Exam: examName, examType, examDate, examTime, totalMarks, passingMarks, subjectId, classId
   - Etc.
4. **Update state classes** similarly (SubjectLoaded → StudentLoaded, etc.)
5. **Update BLoC class name and handlers** accordingly

## Mappings for Each Feature

### Student Feature
- Entity fields: id, firstName, lastName, email, phone, dateOfBirth, gender, classId, status
- Additional events: GetStudentPerformanceEvent, GetStudentResultsEvent, GetStudentAttendanceEvent
- Additional states: StudentPerformanceLoaded, StudentResultsLoaded, StudentAttendanceSummaryLoaded

### Exam Feature
- Entity fields: id, examName, examType, examDate, examTime, totalMarks, passingMarks, subjectId, classId
- Additional events: GetUpcomingExamsEvent, GetExamsByClassEvent, GetExamResultsEvent
- Additional states: UpcomingExamsLoaded, ExamsByClassLoaded, ExamResultsLoaded

### ExamResult Feature
- Entity fields: id, examId, studentId, marksObtained, grade, status, attempt
- Additional events: GetStudentResultsEvent, GetClassResultsEvent, GetExamStatisticsEvent
- Additional states: StudentResultsLoaded, ClassResultsLoaded, ExamStatisticsLoaded

### Attendance Feature
- Entity fields: id, studentId, classId, attendanceDate, status, remarks
- Additional events: MarkAttendanceEvent, GetStudentAttendanceEvent, GetClassAttendanceEvent, GetAttendanceSummaryEvent, MarkBulkAttendanceEvent
- Additional states: AttendanceMarked, StudentAttendanceLoaded, ClassAttendanceLoaded, AttendanceSummaryLoaded, BulkAttendanceMarked

### Parent Feature
- Entity fields: id, studentId, parentName, relationship, phone, email, occupation
- Additional events: GetParentChildrenEvent, LinkParentToStudentEvent, UnlinkParentFromStudentEvent
- Additional states: ParentChildrenLoaded, ParentLinked, ParentUnlinked

## Final Step: Update Injection Container

Add to `lib/core/di/injection_container.dart` in setupServiceLocator():

```dart
// Add these imports at the top
import '../../presentation/bloc/subject/subject_bloc.dart';
import '../../presentation/bloc/student/student_bloc.dart';
import '../../presentation/bloc/exam/exam_bloc.dart';
import '../../presentation/bloc/exam_result/exam_result_bloc.dart';
import '../../presentation/bloc/attendance/attendance_bloc.dart';
import '../../presentation/bloc/parent/parent_bloc.dart';

// Add these registrations in setupServiceLocator()
getIt.registerSingleton<SubjectBloc>(SubjectBloc(getIt<SubjectUseCases>()));
getIt.registerSingleton<StudentBloc>(StudentBloc(getIt<StudentUseCases>()));
getIt.registerSingleton<ExamBloc>(ExamBloc(getIt<ExamUseCases>()));
getIt.registerSingleton<ExamResultBloc>(ExamResultBloc(getIt<ExamResultUseCases>()));
getIt.registerSingleton<AttendanceBloc>(AttendanceBloc(getIt<AttendanceUseCases>()));
getIt.registerSingleton<ParentBloc>(ParentBloc(getIt<ParentUseCases>()));
```

## Time Estimate

- Per feature BLoCs: ~10-15 minutes each (copy + adapt)
- Total for 6 remaining features: ~60-90 minutes
- Total files to create: 18 (6 features × 3 files each)

## Validation Checklist

For each created BLoC:
- [ ] Events have proper @override on props getter
- [ ] States have proper @override on props getter
- [ ] BLoC handlers use logger with correct messages
- [ ] Error handling uses failure.message
- [ ] Data mapping uses correct field names
- [ ] Imports are correct
- [ ] Registered in injection_container.dart

---

All repositories and use cases are already complete - these remaining BLoCs will complete the presentation layer!
