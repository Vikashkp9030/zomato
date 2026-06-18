import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final dynamic id; // Can be int or String from API
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String role;
  final String? profileImage;
  final String status; // From API: Active/Inactive
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.profileImage,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both camelCase and snake_case field names from API
    final firstName = (json['first_name'] ?? json['firstName']) as String? ?? '';
    final lastName = (json['last_name'] ?? json['lastName']) as String? ?? '';
    final status = json['status'] as String? ?? 'Active';
    final createdAtStr = (json['created_at'] ?? json['createdAt']) as String?;
    final updatedAtStr = (json['updated_at'] ?? json['updatedAt']) as String?;

    return UserModel(
      id: json['id'],
      firstName: firstName,
      lastName: lastName,
      email: json['email'] as String,
      phoneNumber: (json['phone_number'] ?? json['phoneNumber']) as String?,
      role: json['role'] as String? ?? 'user',
      profileImage: (json['profile_image'] ?? json['profileImage']) as String?,
      status: status,
      createdAt: createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now(),
      updatedAt: updatedAtStr != null ? DateTime.parse(updatedAtStr) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'role': role,
    'profile_image': profileImage,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phoneNumber,
    role,
    profileImage,
    status,
    createdAt,
    updatedAt,
  ];
}
