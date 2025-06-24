import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../models/login.dart';
import 'package:ams/user_login/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  User? _currentUser;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    if (kDebugMode) {
      print('[AuthBloc] Initialized');
    }

    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  User? get currentUser => _currentUser;

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    try {
      if (kDebugMode) {
        print('[AuthBloc] Processing login request');
      }

      emit(AuthLoading());

      final user = await authRepository.login(event.loginRequest);
      _currentUser = user;

      if (kDebugMode) {
        print('[AuthBloc] Login successful for: ${user.fullName} (${user.role.displayName})');
      }

      emit(AuthAuthenticated(user));
    } catch (e) {
      if (kDebugMode) {
        print('[AuthBloc] Login failed: $e');
      }

      _currentUser = null;
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      if (kDebugMode) {
        print('[AuthBloc] Processing logout request');
      }

      await authRepository.logout();
      _currentUser = null;
      emit(AuthUnauthenticated());
    } catch (e) {
      if (kDebugMode) {
        print('[AuthBloc] Logout error: $e');
      }
      // Even if logout fails, clear the user
      _currentUser = null;
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    if (_currentUser != null) {
      emit(AuthAuthenticated(_currentUser!));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
