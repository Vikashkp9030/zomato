import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/local_storage.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService authApiService;
  final LocalStorage localStorage;
  final Logger _logger = Logger();

  AuthRepositoryImpl(
    this.authApiService,
    this.localStorage,
  );

  @override
  Future<Either<Failure, TokenEntity>> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await authApiService.login(request);

      await localStorage.saveToken(response.accessToken);
      await localStorage.saveRefreshToken(response.refreshToken);
      await localStorage.saveUserData(response.user.toJson().toString());

      _logger.i('Login successful for ${response.user.email}');

      return Right(
        TokenEntity(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          user: _mapUserModelToEntity(response.user),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, TokenEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String role,
  }) async {
    try {
      final request = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        role: role,
      );

      final response = await authApiService.register(request);

      await localStorage.saveToken(response.accessToken);
      await localStorage.saveRefreshToken(response.refreshToken);
      await localStorage.saveUserData(response.user.toJson().toString());

      _logger.i('Registration successful for $email');

      return Right(
        TokenEntity(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          user: _mapUserModelToEntity(response.user),
        ),
      );
    } on DioException catch (e) {
      final message = e.message?.toString() ?? 'Network error';
      return Left(NetworkFailure(message: message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Registration failed'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authApiService.logout();
      await localStorage.clearAuthData();
      _logger.i('Logout successful');
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: 'Logout failed'));
    }
  }

  @override
  Future<Either<Failure, TokenEntity>> refreshToken(String refreshToken) async {
    try {
      final response = await authApiService.refreshToken(refreshToken);

      await localStorage.saveToken(response.accessToken);
      await localStorage.saveRefreshToken(response.refreshToken);

      return Right(
        TokenEntity(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          user: _mapUserModelToEntity(response.user),
        ),
      );
    } catch (e) {
      return Left(NetworkFailure(message: 'Token refresh failed'));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    try {
      await authApiService.requestPasswordReset(email);
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: 'Password reset request failed'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await authApiService.resetPassword(token, newPassword, confirmPassword);
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: 'Password reset failed'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    try {
      await authApiService.verifyEmail(token);
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: 'Email verification failed'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final userData = localStorage.getUserData();
      if (userData == null) {
        return Left(NoDataFailure(message: 'No user data found'));
      }
      return Right(AuthEntity(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
        role: '',
        isActive: true,
        createdAt: DateTime.now(),
      ));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get current user'));
    }
  }

  AuthEntity _mapUserModelToEntity(dynamic userModel) {
    return AuthEntity(
      id: userModel.id.toString(),
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      email: userModel.email,
      phoneNumber: userModel.phoneNumber ?? '',
      role: userModel.role,
      profileImage: userModel.profileImage,
      isActive: (userModel.status?.toLowerCase() ?? '') == 'active',
      createdAt: userModel.createdAt,
    );
  }
}
