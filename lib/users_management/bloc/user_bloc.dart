import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'user_event.dart';
import 'user_state.dart';
import 'package:ams/users_management/models/user.dart';
import 'package:ams/users_management/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  List<User> _users = [];
  List<User> _filteredUsers = [];
  UserRole? _selectedRole;
  String _searchQuery = '';

  UserBloc({required this.userRepository}) : super(UserLoading()) {
    if (kDebugMode) {
      print("[UserBloc] Initialized.");
    }

    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
    on<FilterUsersByRole>(_onFilterUsersByRole);
    on<SearchUsers>(_onSearchUsers);

    // Load users on initialization
    add(LoadUsers());
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    try {
      if (kDebugMode) {
        print("[UserBloc] Processing LoadUsers event");
      }

      emit(UserLoading());
      _users = await userRepository.fetchUsers();
      _applyFilters();

      if (kDebugMode) {
        print("[UserBloc] Emitting UsersLoaded with ${_users.length} users");
      }

      emit(UsersLoaded(
        users: List.from(_users),
        filteredUsers: List.from(_filteredUsers),
        selectedRole: _selectedRole,
        searchQuery: _searchQuery,
      ));
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print("[UserBloc] Error loading users: $e");
        print("[UserBloc] Stacktrace: $stacktrace");
      }
      emit(UserOperationFailure('Failed to load users: ${e.toString()}', _users));
    }
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    try {
      emit(UserOperationInProgress(List.from(_users), "Adding user..."));

      await userRepository.addUser(event.user);
      emit(UserOperationSuccess(List.from(_users), "User added successfully!"));

      // Reload users to get the updated list from server
      add(LoadUsers());
    } catch (e) {
      emit(UserOperationFailure('Failed to add user: ${e.toString()}', List.from(_users)));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      emit(UserOperationInProgress(List.from(_users), "Updating user..."));

      await userRepository.updateUser(event.user);

      // Update local cache
      final index = _users.indexWhere((u) => u.id == event.user.id);
      if (index != -1) {
        _users[index] = event.user;
        _applyFilters();
      }

      emit(UserOperationSuccess(List.from(_users), "User updated successfully!"));
      emit(UsersLoaded(
        users: List.from(_users),
        filteredUsers: List.from(_filteredUsers),
        selectedRole: _selectedRole,
        searchQuery: _searchQuery,
      ));
    } catch (e) {
      emit(UserOperationFailure('Failed to update user: ${e.toString()}', List.from(_users)));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      emit(UserOperationInProgress(List.from(_users), "Deleting user..."));

      await userRepository.deleteUser(event.userId);

      // Remove from local cache
      _users.removeWhere((u) => u.id == event.userId);
      _applyFilters();

      emit(UserOperationSuccess(List.from(_users), "User deleted successfully!"));
      emit(UsersLoaded(
        users: List.from(_users),
        filteredUsers: List.from(_filteredUsers),
        selectedRole: _selectedRole,
        searchQuery: _searchQuery,
      ));
    } catch (e) {
      emit(UserOperationFailure('Failed to delete user: ${e.toString()}', List.from(_users)));
    }
  }

  void _onFilterUsersByRole(FilterUsersByRole event, Emitter<UserState> emit) {
    _selectedRole = event.role;
    _applyFilters();

    if (state is UsersLoaded) {
      emit((state as UsersLoaded).copyWith(
        filteredUsers: List.from(_filteredUsers),
        selectedRole: _selectedRole,
      ));
    }
  }

  void _onSearchUsers(SearchUsers event, Emitter<UserState> emit) {
    _searchQuery = event.query;
    _applyFilters();

    if (state is UsersLoaded) {
      emit((state as UsersLoaded).copyWith(
        filteredUsers: List.from(_filteredUsers),
        searchQuery: _searchQuery,
      ));
    }
  }

  void _applyFilters() {
    List<User> filtered = List.from(_users);

    // Apply role filter
    if (_selectedRole != null) {
      filtered = filtered.where((user) => user.role == _selectedRole).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((user) =>
      user.fullName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.phone.contains(query)
      ).toList();
    }

    _filteredUsers = filtered;
  }
}