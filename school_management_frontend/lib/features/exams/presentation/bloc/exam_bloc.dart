import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/exam_usecases.dart';
import 'exam_event.dart';
import 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final ExamUseCases useCases;

  ExamBloc(this.useCases) : super(const ExamInitial()) {
    on<GetAllExamsEvent>(_onGetAllExams);
    on<GetExamByIdEvent>(_onGetExamById);
    on<CreateExamEvent>(_onCreateExam);
    on<UpdateExamEvent>(_onUpdateExam);
    on<DeleteExamEvent>(_onDeleteExam);
    on<GetUpcomingExamsEvent>(_onGetUpcomingExams);
    on<GetExamsByClassEvent>(_onGetExamsByClass);
    on<GetExamResultsEvent>(_onGetExamResults);
    on<SearchExamsEvent>(_onSearchExams);
  }

  Future<void> _onGetAllExams(
    GetAllExamsEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());
    final result = await useCases.getAllExams(
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (failure) => emit(ExamError(message: failure.message)),
      (exams) => emit(ExamsLoaded(exams: exams)),
    );
  }

  Future<void> _onGetExamById(
    GetExamByIdEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());
    final result = await useCases.getExamById(event.id);
    result.fold(
      (failure) => emit(ExamError(message: failure.message)),
      (exam) => emit(ExamLoaded(exam: exam)),
    );
  }

  Future<void> _onCreateExam(
    CreateExamEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());
    final result = await useCases.createExam(event.data);
    result.fold(
      (failure) => emit(ExamError(message: failure.message)),
      (exam) => emit(ExamCreated(exam: exam)),
    );
  }

  Future<void> _onUpdateExam(
    UpdateExamEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());
    final result = await useCases.updateExam(event.id, event.data);
    result.fold(
      (failure) => emit(ExamError(message: failure.message)),
      (exam) => emit(ExamUpdated(exam: exam)),
    );
  }

  Future<void> _onDeleteExam(
    DeleteExamEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());
    final result = await useCases.deleteExam(event.id);
    result.fold(
      (failure) => emit(ExamError(message: failure.message)),
      (_) => emit(const ExamDeleted()),
    );
  }

  Future<void> _onGetUpcomingExams(
    GetUpcomingExamsEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());
    final result = await useCases.getUpcomingExams();
    result.fold(
      (failure) => emit(ExamError(message: failure.message)),
      (exams) => emit(UpcomingExamsLoaded(exams: exams)),
    );
  }

  Future<void> _onGetExamsByClass(
    GetExamsByClassEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());
    final result = await useCases.getExamsByClass(event.classId);
    result.fold(
      (failure) => emit(ExamError(message: failure.message)),
      (exams) => emit(ExamsByClassLoaded(exams: exams)),
    );
  }

  Future<void> _onGetExamResults(
    GetExamResultsEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());
    final result = await useCases.getExamResults(event.examId);
    result.fold(
      (failure) => emit(ExamError(message: failure.message)),
      (results) => emit(ExamResultsLoaded(results: results)),
    );
  }

  Future<void> _onSearchExams(
    SearchExamsEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(const ExamLoading());
    final result = await useCases.getAllExams();
    result.fold(
      (failure) => emit(ExamError(message: failure.message)),
      (exams) {
        final filtered = exams
            .where((e) => e.examName.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(ExamsSearchLoaded(exams: filtered));
      },
    );
  }
}
