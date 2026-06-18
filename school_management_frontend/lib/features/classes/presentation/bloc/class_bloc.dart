import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/class_usecases.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassUseCases classUseCases;
  final Logger _logger = Logger();

  ClassBloc(this.classUseCases) : super(const ClassInitial()) {
    on<GetAllClassesEvent>(_onGetAllClasses);
    on<GetClassByIdEvent>(_onGetClassById);
    on<CreateClassEvent>(_onCreateClass);
    on<UpdateClassEvent>(_onUpdateClass);
    on<DeleteClassEvent>(_onDeleteClass);
    on<GetClassStudentsEvent>(_onGetClassStudents);
    on<GetClassSubjectsEvent>(_onGetClassSubjects);
  }

  Future<void> _onGetAllClasses(
    GetAllClassesEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassLoading());
    final result = await classUseCases.getAllClasses(page: event.page, limit: event.limit);
    result.fold(
      (failure) => emit(ClassError(message: failure.message)),
      (classes) => emit(ClassesLoaded(classes: classes, page: event.page, limit: event.limit)),
    );
  }

  Future<void> _onGetClassById(
    GetClassByIdEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassLoading());
    final result = await classUseCases.getClassById(event.id);
    result.fold(
      (failure) => emit(ClassError(message: failure.message)),
      (classEntity) => emit(ClassLoaded(classEntity: classEntity)),
    );
  }

  Future<void> _onCreateClass(
    CreateClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassLoading());
    final data = {
      'class_name': event.className,
      'grade_level': event.gradeLevel,
      'section': event.section,
      'capacity': event.capacity,
      'class_teacher_id': event.classTeacherId,
      'room_number': event.roomNumber,
    };
    final result = await classUseCases.createClass(data);
    result.fold(
      (failure) => emit(ClassError(message: failure.message)),
      (classEntity) {
        _logger.i('Class created: ${classEntity.className}');
        emit(ClassCreated(classEntity: classEntity));
      },
    );
  }

  Future<void> _onUpdateClass(
    UpdateClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassLoading());
    final data = {
      'class_name': event.className,
      'grade_level': event.gradeLevel,
      'section': event.section,
      'capacity': event.capacity,
      'class_teacher_id': event.classTeacherId,
      'room_number': event.roomNumber,
    };
    final result = await classUseCases.updateClass(event.id, data);
    result.fold(
      (failure) => emit(ClassError(message: failure.message)),
      (classEntity) {
        _logger.i('Class updated: ${classEntity.className}');
        emit(ClassUpdated(classEntity: classEntity));
      },
    );
  }

  Future<void> _onDeleteClass(
    DeleteClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassLoading());
    final result = await classUseCases.deleteClass(event.id);
    result.fold(
      (failure) => emit(ClassError(message: failure.message)),
      (_) {
        _logger.i('Class deleted: ${event.id}');
        emit(const ClassDeleted());
      },
    );
  }

  Future<void> _onGetClassStudents(
    GetClassStudentsEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassLoading());
    final result = await classUseCases.getClassStudents(event.classId);
    result.fold(
      (failure) => emit(ClassError(message: failure.message)),
      (students) => emit(ClassStudentsLoaded(students: students)),
    );
  }

  Future<void> _onGetClassSubjects(
    GetClassSubjectsEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassLoading());
    final result = await classUseCases.getClassSubjects(event.classId);
    result.fold(
      (failure) => emit(ClassError(message: failure.message)),
      (subjects) => emit(ClassSubjectsLoaded(subjects: subjects)),
    );
  }
}
