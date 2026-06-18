import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String role;

  const RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.role,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    confirmPassword,
    phoneNumber,
    role,
  ];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  const RefreshTokenEvent({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}

class RequestPasswordResetEvent extends AuthEvent {
  final String email;

  const RequestPasswordResetEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordEvent extends AuthEvent {
  final String token;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordEvent({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [token, newPassword, confirmPassword];
}

class VerifyEmailEvent extends AuthEvent {
  final String token;

  const VerifyEmailEvent({required this.token});

  @override
  List<Object?> get props => [token];
}
