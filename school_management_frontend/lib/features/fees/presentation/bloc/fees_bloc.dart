import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/fees_usecases.dart';
import 'fees_event.dart';
import 'fees_state.dart';

class FeesBloc extends Bloc<FeesEvent, FeesState> {
  final FeesUseCases useCases;
  final Logger _logger = Logger();

  FeesBloc(this.useCases) : super(const FeesInitialState()) {
    on<FetchFeesEvent>(_onFetchFees);
    on<FetchFeesByStatusEvent>(_onFetchFeesByStatus);
    on<FetchStudentFeesEvent>(_onFetchStudentFees);
    on<FetchFeeSummaryEvent>(_onFetchFeeSummary);
    on<PayFeeEvent>(_onPayFee);
    on<FetchFeeReceiptEvent>(_onFetchReceipt);
    on<CreateFeeEvent>(_onCreateFee);
  }

  Future<void> _onFetchFees(FetchFeesEvent event, Emitter<FeesState> emit) async {
    emit(const FeesLoadingState());
    final result = await useCases.getAllFees(page: event.page, limit: event.limit);
    result.fold(
      (failure) => emit(FeesErrorState(message: failure.message)),
      (fees) => emit(FeesLoadedState(fees: fees)),
    );
  }

  Future<void> _onFetchFeesByStatus(FetchFeesByStatusEvent event, Emitter<FeesState> emit) async {
    emit(const FeesLoadingState());
    final result = await useCases.getFeesByStatus(
      status: event.status,
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (failure) => emit(FeesErrorState(message: failure.message)),
      (fees) => emit(FeesLoadedState(fees: fees)),
    );
  }

  Future<void> _onFetchStudentFees(FetchStudentFeesEvent event, Emitter<FeesState> emit) async {
    emit(const FeesLoadingState());
    final result = await useCases.getStudentFees(event.studentId);
    result.fold(
      (failure) => emit(FeesErrorState(message: failure.message)),
      (fees) => emit(StudentFeesLoadedState(fees: fees)),
    );
  }

  Future<void> _onFetchFeeSummary(FetchFeeSummaryEvent event, Emitter<FeesState> emit) async {
    emit(const FeesLoadingState());
    final result = await useCases.getFeeSummary(event.studentId);
    result.fold(
      (failure) => emit(FeesErrorState(message: failure.message)),
      (summary) => emit(FeeSummaryLoadedState(summary: summary)),
    );
  }

  Future<void> _onPayFee(PayFeeEvent event, Emitter<FeesState> emit) async {
    emit(const FeesLoadingState());
    final result = await useCases.payFee(event.feeId, event.paymentMethod);
    result.fold(
      (failure) {
        _logger.e('Payment failed: ${failure.message}');
        emit(FeesErrorState(message: failure.message));
      },
      (receipt) {
        _logger.i('Payment successful');
        emit(PaymentSuccessState(receipt: receipt));
      },
    );
  }

  Future<void> _onFetchReceipt(FetchFeeReceiptEvent event, Emitter<FeesState> emit) async {
    emit(const FeesLoadingState());
    final result = await useCases.generateReceipt(event.feeId);
    result.fold(
      (failure) => emit(FeesErrorState(message: failure.message)),
      (receipt) => emit(ReceiptGeneratedState(receipt: receipt)),
    );
  }

  Future<void> _onCreateFee(CreateFeeEvent event, Emitter<FeesState> emit) async {
    emit(const FeesLoadingState());
    final result = await useCases.createFee(
      studentId: event.studentId,
      amount: event.amount,
      description: event.description,
    );
    result.fold(
      (failure) {
        _logger.e('Fee creation failed: ${failure.message}');
        emit(FeesErrorState(message: failure.message));
      },
      (fee) {
        _logger.i('Fee created successfully');
        emit(FeeCreatedState(fee: fee));
      },
    );
  }
}
