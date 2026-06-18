import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases authUseCases;
  final Logger _logger = Logger();

  AuthBloc(this.authUseCases) : super(const AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<RequestPasswordResetEvent>(_onRequestPasswordReset);
    on<ResetPasswordEvent>(_onResetPassword);
    on<VerifyEmailEvent>(_onVerifyEmail);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await authUseCases.getCurrentUser();
      result.fold(
        (failure) => emit(const AuthUnauthenticated()),
        (user) => emit(AuthAuthenticated(user: user, accessToken: '')),
      );
    } catch (e) {
      _logger.e('Check auth status error: $e');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authUseCases.login(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (token) => emit(AuthAuthenticated(user: token.user, accessToken: token.accessToken)),
    );
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authUseCases.register(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
      phoneNumber: event.phoneNumber,
      role: event.role,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (token) => emit(AuthRegistrationSuccess(user: token.user)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authUseCases.logout();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await authUseCases.refreshToken(event.refreshToken);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (token) => emit(AuthAuthenticated(user: token.user, accessToken: token.accessToken)),
    );
  }

  Future<void> _onRequestPasswordReset(
    RequestPasswordResetEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authUseCases.requestPasswordReset(event.email);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const PasswordResetEmailSent()),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authUseCases.resetPassword(
      token: event.token,
      newPassword: event.newPassword,
      confirmPassword: event.confirmPassword,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const PasswordResetSuccess()),
    );
  }

  Future<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authUseCases.verifyEmail(event.token);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const EmailVerificationSuccess()),
    );
  }
}
