import 'package:equatable/equatable.dart';

abstract class FeesEvent extends Equatable {
  const FeesEvent();

  @override
  List<Object?> get props => [];
}

class FetchFeesEvent extends FeesEvent {
  final int page;
  final int limit;

  const FetchFeesEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class FetchFeesByStatusEvent extends FeesEvent {
  final String status;
  final int page;
  final int limit;

  const FetchFeesByStatusEvent({required this.status, this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [status, page, limit];
}

class FetchStudentFeesEvent extends FeesEvent {
  final String studentId;

  const FetchStudentFeesEvent({required this.studentId});

  @override
  List<Object?> get props => [studentId];
}

class FetchFeeSummaryEvent extends FeesEvent {
  final String studentId;

  const FetchFeeSummaryEvent({required this.studentId});

  @override
  List<Object?> get props => [studentId];
}

class PayFeeEvent extends FeesEvent {
  final String feeId;
  final String paymentMethod;

  const PayFeeEvent({required this.feeId, required this.paymentMethod});

  @override
  List<Object?> get props => [feeId, paymentMethod];
}

class FetchFeeReceiptEvent extends FeesEvent {
  final String feeId;

  const FetchFeeReceiptEvent({required this.feeId});

  @override
  List<Object?> get props => [feeId];
}

class CreateFeeEvent extends FeesEvent {
  final String studentId;
  final double amount;
  final String description;

  const CreateFeeEvent({
    required this.studentId,
    required this.amount,
    required this.description,
  });

  @override
  List<Object?> get props => [studentId, amount, description];
}
