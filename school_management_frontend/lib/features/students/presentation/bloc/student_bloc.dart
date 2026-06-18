import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/student_usecases.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentUseCases useCases;

  StudentBloc(this.useCases) : super(const StudentInitial()) {
    on<GetAllStudentsEvent>(_onGetAllStudents);
    on<GetStudentByIdEvent>(_onGetStudentById);
    on<CreateStudentEvent>(_onCreateStudent);
    on<UpdateStudentEvent>(_onUpdateStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
    on<SearchStudentsEvent>(_onSearchStudents);
    on<GetStudentPerformanceEvent>(_onGetStudentPerformance);
    on<GetStudentResultsEvent>(_onGetStudentResults);
    on<GetStudentAttendanceEvent>(_onGetStudentAttendance);
  }

  Future<void> _onGetAllStudents(
    GetAllStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await useCases.getAllStudents(
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (failure) => emit(StudentError(message: failure.message)),
      (students) => emit(StudentsLoaded(students: students)),
    );
  }

  Future<void> _onGetStudentById(
    GetStudentByIdEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await useCases.getStudentById(event.id);
    result.fold(
      (failure) => emit(StudentError(message: failure.message)),
      (student) => emit(StudentLoaded(student: student)),
    );
  }

  Future<void> _onCreateStudent(
    CreateStudentEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await useCases.createStudent(event.data);
    result.fold(
      (failure) => emit(StudentError(message: failure.message)),
      (student) => emit(StudentCreated(student: student)),
    );
  }

  Future<void> _onUpdateStudent(
    UpdateStudentEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await useCases.updateStudent(event.id, event.data);
    result.fold(
      (failure) => emit(StudentError(message: failure.message)),
      (student) => emit(StudentUpdated(student: student)),
    );
  }

  Future<void> _onDeleteStudent(
    DeleteStudentEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await useCases.deleteStudent(event.id);
    result.fold(
      (failure) => emit(StudentError(message: failure.message)),
      (_) => emit(const StudentDeleted()),
    );
  }

  Future<void> _onSearchStudents(
    SearchStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await useCases.getAllStudents();
    result.fold(
      (failure) => emit(StudentError(message: failure.message)),
      (students) {
        final filtered = students
            .where((s) => s.firstName.toLowerCase().contains(event.query.toLowerCase()) ||
                s.lastName.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(StudentsSearchLoaded(students: filtered));
      },
    );
  }

  Future<void> _onGetStudentPerformance(
    GetStudentPerformanceEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await useCases.getStudentPerformance(event.studentId);
    result.fold(
      (failure) => emit(StudentError(message: failure.message)),
      (performance) => emit(StudentPerformanceLoaded(performance: performance)),
    );
  }

  Future<void> _onGetStudentResults(
    GetStudentResultsEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await useCases.getStudentResults(event.studentId);
    result.fold(
      (failure) => emit(StudentError(message: failure.message)),
      (results) => emit(StudentResultsLoaded(results: results)),
    );
  }

  Future<void> _onGetStudentAttendance(
    GetStudentAttendanceEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(const StudentLoading());
    final result = await useCases.getStudentAttendance(event.studentId);
    result.fold(
      (failure) => emit(StudentError(message: failure.message)),
      (attendance) => emit(StudentAttendanceLoaded(attendance: attendance)),
    );
  }
}
