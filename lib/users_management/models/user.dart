import 'package:equatable/equatable.dart';
import 'package:ams/services/common_model.dart';

class User extends Equatable {
  final int? id;
  final String email;
  final String phone;
  final String? password;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final UserRole role;
  final String? createdAt;
  final String? updatedAt;

  const User({
    this.id,
    required this.email,
    required this.phone,
    this.password,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePicture: json['profilePicture'],
      role: UserRole.fromString(json['role'] ?? 'EMPLOYEE'),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.name,
    };

    if (id != null) data['id'] = id;
    if (password != null) data['password'] = password;
    if (profilePicture != null) data['profilePicture'] = profilePicture;

    return data;
  }

  User copyWith({
    int? id,
    String? email,
    String? phone,
    String? password,
    String? firstName,
    String? lastName,
    String? profilePicture,
    UserRole? role,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  @override
  List<Object?> get props => [
    id,
    email,
    phone,
    firstName,
    lastName,
    profilePicture,
    role,
    createdAt,
    updatedAt,
  ];
}