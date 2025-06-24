
import 'package:equatable/equatable.dart';
import 'package:ams/services/common_model.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final UserRole role;
  final String createdAt;

  const User({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'EMPLOYEE'),
      createdAt: json['createdAt'] ?? DateTime.now().toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.name,
      'createdAt': createdAt,
    };
  }

  String get fullName => '$firstName $lastName';

  // Clean role checking methods using enum
  bool get isAdmin => role == UserRole.ADMIN;
  bool get isAssetManager => role == UserRole.ASSET_MANAGER;
  bool get isEmployee => role == UserRole.EMPLOYEE;

  @override
  List<Object?> get props => [id, email, phone, firstName, lastName, role, createdAt];
}