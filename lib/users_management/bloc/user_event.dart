import 'package:equatable/equatable.dart';
import 'package:ams/users_management/models/user.dart';
import 'package:ams/services/common_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {}

class AddUser extends UserEvent {
  final User user;
  const AddUser(this.user);
  @override
  List<Object?> get props => [user];
}

class UpdateUser extends UserEvent {
  final User user;
  const UpdateUser(this.user);
  @override
  List<Object?> get props => [user];
}

class DeleteUser extends UserEvent {
  final int userId;
  const DeleteUser(this.userId);
  @override
  List<Object?> get props => [userId];
}

class FilterUsersByRole extends UserEvent {
  final UserRole? role;
  const FilterUsersByRole(this.role);
  @override
  List<Object?> get props => [role];
}

class SearchUsers extends UserEvent {
  final String query;
  const SearchUsers(this.query);
  @override
  List<Object?> get props => [query];
}