import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases(this.repository);

  Future<Either<Failure, TokenEntity>> login(String email, String password) {
    return repository.login(email, password);
  }

  Future<Either<Failure, TokenEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String role,
  }) {
    return repository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      role: role,
    );
  }

  Future<Either<Failure, void>> logout() {
    return repository.logout();
  }

  Future<Either<Failure, TokenEntity>> refreshToken(String refreshToken) {
    return repository.refreshToken(refreshToken);
  }

  Future<Either<Failure, void>> requestPasswordReset(String email) {
    return repository.requestPasswordReset(email);
  }

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) {
    return repository.resetPassword(
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  Future<Either<Failure, void>> verifyEmail(String token) {
    return repository.verifyEmail(token);
  }

  Future<Either<Failure, AuthEntity>> getCurrentUser() {
    return repository.getCurrentUser();
  }
}
