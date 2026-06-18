import 'package:equatable/equatable.dart';
import 'user_model.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final String message;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Handle both wrapped (data object) and unwrapped responses
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return AuthResponse(
      accessToken: (data['access_token'] ?? data['accessToken']) as String,
      refreshToken: (data['refresh_token'] ?? data['refreshToken']) as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      message: (json['message'] ?? data['message']) as String? ?? 'Success',
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'user': user.toJson(),
    'message': message,
  };

  @override
  List<Object?> get props => [accessToken, refreshToken, user, message];
}
