import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/exam_result_usecases.dart';
import 'exam_result_event.dart';
import 'exam_result_state.dart';

class ExamResultBloc extends Bloc<ExamResultEvent, ExamResultState> {
  final ExamResultUseCases useCases;

  ExamResultBloc(this.useCases) : super(const ExamResultInitial()) {
    on<GetAllResultsEvent>(_onGetAllResults);
    on<GetResultByIdEvent>(_onGetResultById);
    on<CreateResultEvent>(_onCreateResult);
    on<UpdateResultEvent>(_onUpdateResult);
    on<DeleteResultEvent>(_onDeleteResult);
    on<GetStudentResultsEvent>(_onGetStudentResults);
    on<GetClassResultsEvent>(_onGetClassResults);
    on<GetExamStatisticsEvent>(_onGetExamStatistics);
    on<SearchResultsEvent>(_onSearchResults);
  }

  Future<void> _onGetAllResults(
    GetAllResultsEvent event,
    Emitter<ExamResultState> emit,
  ) async {
    emit(const ExamResultLoading());
    final result = await useCases.getAllResults(
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (failure) => emit(ExamResultError(message: failure.message)),
      (results) => emit(ExamResultsLoaded(results: results)),
    );
  }

  Future<void> _onGetResultById(
    GetResultByIdEvent event,
    Emitter<ExamResultState> emit,
  ) async {
    emit(const ExamResultLoading());
    final result = await useCases.getResultById(event.id);
    result.fold(
      (failure) => emit(ExamResultError(message: failure.message)),
      (result) => emit(ExamResultLoaded(result: result)),
    );
  }

  Future<void> _onCreateResult(
    CreateResultEvent event,
    Emitter<ExamResultState> emit,
  ) async {
    emit(const ExamResultLoading());
    final result = await useCases.createResult(event.data);
    result.fold(
      (failure) => emit(ExamResultError(message: failure.message)),
      (result) => emit(ExamResultCreated(result: result)),
    );
  }

  Future<void> _onUpdateResult(
    UpdateResultEvent event,
    Emitter<ExamResultState> emit,
  ) async {
    emit(const ExamResultLoading());
    final result = await useCases.updateResult(event.id, event.data);
    result.fold(
      (failure) => emit(ExamResultError(message: failure.message)),
      (result) => emit(ExamResultUpdated(result: result)),
    );
  }

  Future<void> _onDeleteResult(
    DeleteResultEvent event,
    Emitter<ExamResultState> emit,
  ) async {
    emit(const ExamResultLoading());
    final result = await useCases.deleteResult(event.id);
    result.fold(
      (failure) => emit(ExamResultError(message: failure.message)),
      (_) => emit(const ExamResultDeleted()),
    );
  }

  Future<void> _onGetStudentResults(
    GetStudentResultsEvent event,
    Emitter<ExamResultState> emit,
  ) async {
    emit(const ExamResultLoading());
    final result = await useCases.getStudentResults(event.studentId);
    result.fold(
      (failure) => emit(ExamResultError(message: failure.message)),
      (results) => emit(StudentResultsLoaded(results: results)),
    );
  }

  Future<void> _onGetClassResults(
    GetClassResultsEvent event,
    Emitter<ExamResultState> emit,
  ) async {
    emit(const ExamResultLoading());
    final result = await useCases.getClassResults(event.classId);
    result.fold(
      (failure) => emit(ExamResultError(message: failure.message)),
      (results) => emit(ClassResultsLoaded(results: results)),
    );
  }

  Future<void> _onGetExamStatistics(
    GetExamStatisticsEvent event,
    Emitter<ExamResultState> emit,
  ) async {
    emit(const ExamResultLoading());
    final result = await useCases.getExamStatistics(event.examId);
    result.fold(
      (failure) => emit(ExamResultError(message: failure.message)),
      (statistics) => emit(ExamStatisticsLoaded(statistics: statistics)),
    );
  }

  Future<void> _onSearchResults(
    SearchResultsEvent event,
    Emitter<ExamResultState> emit,
  ) async {
    emit(const ExamResultLoading());
    final result = await useCases.getAllResults();
    result.fold(
      (failure) => emit(ExamResultError(message: failure.message)),
      (results) {
        final filtered = results
            .where((r) => r.studentId.toString().contains(event.query) ||
                r.examId.toString().contains(event.query))
            .toList();
        emit(ExamResultsSearchLoaded(results: filtered));
      },
    );
  }
}
