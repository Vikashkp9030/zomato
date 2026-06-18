import '../../../../core/network/dio_client.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthApiService {
  final DioClient dioClient;

  AuthApiService(this.dioClient);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await dioClient.post(
      '/auth/login',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await dioClient.post(
      '/auth/register',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await dioClient.post('/auth/logout');
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await dioClient.post(
      '/auth/refresh-token',
      data: {'refreshToken': refreshToken},
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> requestPasswordReset(String email) async {
    await dioClient.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  Future<void> resetPassword(String token, String newPassword, String confirmPassword) async {
    await dioClient.post(
      '/auth/reset-password',
      data: {
        'token': token,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  }

  Future<void> verifyEmail(String token) async {
    await dioClient.post(
      '/auth/verify-email',
      data: {'token': token},
    );
  }
}
