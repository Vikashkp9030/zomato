import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthEntity user;
  final String accessToken;

  const AuthAuthenticated({
    required this.user,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [user, accessToken];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PasswordResetEmailSent extends AuthState {
  const PasswordResetEmailSent();
}

class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess();
}

class EmailVerificationSuccess extends AuthState {
  const EmailVerificationSuccess();
}

class AuthRegistrationSuccess extends AuthState {
  final AuthEntity user;

  const AuthRegistrationSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}
