import 'package:equatable/equatable.dart';

abstract class FeesState extends Equatable {
  const FeesState();

  @override
  List<Object?> get props => [];
}

class FeesInitialState extends FeesState {
  const FeesInitialState();
}

class FeesLoadingState extends FeesState {
  const FeesLoadingState();
}

class FeesLoadedState extends FeesState {
  final List<dynamic> fees;

  const FeesLoadedState({required this.fees});

  @override
  List<Object?> get props => [fees];
}

class StudentFeesLoadedState extends FeesState {
  final Map<String, dynamic> fees;

  const StudentFeesLoadedState({required this.fees});

  @override
  List<Object?> get props => [fees];
}

class FeeSummaryLoadedState extends FeesState {
  final Map<String, dynamic> summary;

  const FeeSummaryLoadedState({required this.summary});

  @override
  List<Object?> get props => [summary];
}

class PaymentSuccessState extends FeesState {
  final Map<String, dynamic> receipt;

  const PaymentSuccessState({required this.receipt});

  @override
  List<Object?> get props => [receipt];
}

class ReceiptGeneratedState extends FeesState {
  final Map<String, dynamic> receipt;

  const ReceiptGeneratedState({required this.receipt});

  @override
  List<Object?> get props => [receipt];
}

class FeeCreatedState extends FeesState {
  final Map<String, dynamic> fee;

  const FeeCreatedState({required this.fee});

  @override
  List<Object?> get props => [fee];
}

class FeesErrorState extends FeesState {
  final String message;

  const FeesErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
