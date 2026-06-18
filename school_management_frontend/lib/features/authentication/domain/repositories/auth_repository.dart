import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, TokenEntity>> login(String email, String password);
  Future<Either<Failure, TokenEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String role,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, TokenEntity>> refreshToken(String refreshToken);
  Future<Either<Failure, void>> requestPasswordReset(String email);
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  });
  Future<Either<Failure, void>> verifyEmail(String token);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
}
