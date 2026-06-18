import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/subject_usecases.dart';
import 'subject_event.dart';
import 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectUseCases useCases;

  SubjectBloc(this.useCases) : super(const SubjectInitial()) {
    on<GetAllSubjectsEvent>(_onGetAllSubjects);
    on<GetSubjectByIdEvent>(_onGetSubjectById);
    on<CreateSubjectEvent>(_onCreateSubject);
    on<UpdateSubjectEvent>(_onUpdateSubject);
    on<DeleteSubjectEvent>(_onDeleteSubject);
    on<SearchSubjectsEvent>(_onSearchSubjects);
    on<GetSubjectTeachersEvent>(_onGetSubjectTeachers);
    on<GetSubjectClassesEvent>(_onGetSubjectClasses);
  }

  Future<void> _onGetAllSubjects(
    GetAllSubjectsEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await useCases.getAllSubjects(
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (subjects) => emit(SubjectsLoaded(subjects: subjects)),
    );
  }

  Future<void> _onGetSubjectById(
    GetSubjectByIdEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await useCases.getSubjectById(event.id);
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
    final result = await useCases.createSubject(event.data);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (subject) => emit(SubjectCreated(subject: subject)),
    );
  }

  Future<void> _onUpdateSubject(
    UpdateSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await useCases.updateSubject(event.id, event.data);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (subject) => emit(SubjectUpdated(subject: subject)),
    );
  }

  Future<void> _onDeleteSubject(
    DeleteSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await useCases.deleteSubject(event.id);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (_) => emit(const SubjectDeleted()),
    );
  }

  Future<void> _onSearchSubjects(
    SearchSubjectsEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await useCases.getAllSubjects();
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (subjects) {
        final filtered = subjects
            .where((s) => s.subjectName.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(SubjectsSearchLoaded(subjects: filtered));
      },
    );
  }

  Future<void> _onGetSubjectTeachers(
    GetSubjectTeachersEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(const SubjectLoading());
    final result = await useCases.getSubjectTeachers(event.subjectId);
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
    final result = await useCases.getSubjectClasses(event.subjectId);
    result.fold(
      (failure) => emit(SubjectError(message: failure.message)),
      (classes) => emit(SubjectClassesLoaded(classes: classes)),
    );
  }
}
