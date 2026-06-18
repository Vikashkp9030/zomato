import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/teacher_usecases.dart';
import 'teacher_event.dart';
import 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final TeacherUseCases teacherUseCases;
  final Logger _logger = Logger();

  TeacherBloc(this.teacherUseCases) : super(const TeacherInitial()) {
    on<GetAllTeachersEvent>(_onGetAllTeachers);
    on<GetTeacherByIdEvent>(_onGetTeacherById);
    on<CreateTeacherEvent>(_onCreateTeacher);
    on<UpdateTeacherEvent>(_onUpdateTeacher);
    on<DeleteTeacherEvent>(_onDeleteTeacher);
    on<GetTeacherClassesEvent>(_onGetTeacherClasses);
    on<GetTeacherSubjectsEvent>(_onGetTeacherSubjects);
  }

  Future<void> _onGetAllTeachers(GetAllTeachersEvent event, Emitter<TeacherState> emit) async {
    emit(const TeacherLoading());
    final result = await teacherUseCases.getAllTeachers(page: event.page, limit: event.limit);
    result.fold(
      (failure) => emit(TeacherError(message: failure.message)),
      (teachers) => emit(TeachersLoaded(teachers: teachers, page: event.page, limit: event.limit)),
    );
  }

  Future<void> _onGetTeacherById(GetTeacherByIdEvent event, Emitter<TeacherState> emit) async {
    emit(const TeacherLoading());
    final result = await teacherUseCases.getTeacherById(event.id);
    result.fold(
      (failure) => emit(TeacherError(message: failure.message)),
      (teacher) => emit(TeacherLoaded(teacher: teacher)),
    );
  }

  Future<void> _onCreateTeacher(CreateTeacherEvent event, Emitter<TeacherState> emit) async {
    emit(const TeacherLoading());
    final data = {
      'first_name': event.firstName,
      'last_name': event.lastName,
      'email': event.email,
      'phone': event.phone,
      'specialization': event.specialization,
      'salary': event.salary,
      'experience_years': event.experienceYears,
      'hire_date': event.hireDate.toIso8601String(),
    };
    final result = await teacherUseCases.createTeacher(data);
    result.fold(
      (failure) => emit(TeacherError(message: failure.message)),
      (teacher) {
        _logger.i('Teacher created: ${teacher.fullName}');
        emit(TeacherCreated(teacher: teacher));
      },
    );
  }

  Future<void> _onUpdateTeacher(UpdateTeacherEvent event, Emitter<TeacherState> emit) async {
    emit(const TeacherLoading());
    final data = {
      'first_name': event.firstName,
      'last_name': event.lastName,
      'email': event.email,
      'phone': event.phone,
      'specialization': event.specialization,
      'salary': event.salary,
      'experience_years': event.experienceYears,
      'hire_date': event.hireDate.toIso8601String(),
    };
    final result = await teacherUseCases.updateTeacher(event.id, data);
    result.fold(
      (failure) => emit(TeacherError(message: failure.message)),
      (teacher) {
        _logger.i('Teacher updated: ${teacher.fullName}');
        emit(TeacherUpdated(teacher: teacher));
      },
    );
  }

  Future<void> _onDeleteTeacher(DeleteTeacherEvent event, Emitter<TeacherState> emit) async {
    emit(const TeacherLoading());
    final result = await teacherUseCases.deleteTeacher(event.id);
    result.fold(
      (failure) => emit(TeacherError(message: failure.message)),
      (_) {
        _logger.i('Teacher deleted: ${event.id}');
        emit(const TeacherDeleted());
      },
    );
  }

  Future<void> _onGetTeacherClasses(GetTeacherClassesEvent event, Emitter<TeacherState> emit) async {
    emit(const TeacherLoading());
    final result = await teacherUseCases.getTeacherClasses(event.teacherId);
    result.fold(
      (failure) => emit(TeacherError(message: failure.message)),
      (classes) => emit(TeacherClassesLoaded(classes: classes)),
    );
  }

  Future<void> _onGetTeacherSubjects(GetTeacherSubjectsEvent event, Emitter<TeacherState> emit) async {
    emit(const TeacherLoading());
    final result = await teacherUseCases.getTeacherSubjects(event.teacherId);
    result.fold(
      (failure) => emit(TeacherError(message: failure.message)),
      (subjects) => emit(TeacherSubjectsLoaded(subjects: subjects)),
    );
  }
}
