import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role;
  final String? profileImage;
  final bool isActive;
  final DateTime createdAt;

  const AuthEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profileImage,
    required this.isActive,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phoneNumber,
    role,
    profileImage,
    isActive,
    createdAt,
  ];
}

class TokenEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final AuthEntity user;

  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}
