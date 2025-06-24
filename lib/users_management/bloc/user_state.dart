import 'package:equatable/equatable.dart';
import 'package:ams/users_management/models/user.dart';
import 'package:ams/services/common_model.dart';


abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;
  final List<User> filteredUsers;
  final UserRole? selectedRole;
  final String searchQuery;

  const UsersLoaded({
    required this.users,
    required this.filteredUsers,
    this.selectedRole,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [users, filteredUsers, selectedRole, searchQuery];

  UsersLoaded copyWith({
    List<User>? users,
    List<User>? filteredUsers,
    UserRole? selectedRole,
    String? searchQuery,
    bool clearRole = false,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      selectedRole: clearRole ? null : (selectedRole ?? this.selectedRole),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class UserOperationInProgress extends UserState {
  final List<User> currentUsers;
  final String operation;

  const UserOperationInProgress(this.currentUsers, this.operation);

  @override
  List<Object?> get props => [currentUsers, operation];
}

class UserOperationSuccess extends UserState {
  final List<User> users;
  final String message;

  const UserOperationSuccess(this.users, this.message);

  @override
  List<Object?> get props => [users, message];
}

class UserOperationFailure extends UserState {
  final String error;
  final List<User> currentUsers;

  const UserOperationFailure(this.error, this.currentUsers);

  @override
  List<Object?> get props => [error, currentUsers];
}