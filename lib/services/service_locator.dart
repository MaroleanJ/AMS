import 'package:ams/users_management/bloc/user_bloc.dart';
import 'package:ams/users_management/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../dashboard/repositories/dashboard_repository.dart';
import 'mock_data_service.dart';
import 'web_service.dart';
import '../utils/constants.dart';
import 'package:ams/user_login/repositories/auth_repository.dart';
import 'package:ams/user_login/bloc/auth_bloc.dart';

class ServiceLocator {
  static ServiceLocator? _instance;
  static ServiceLocator get instance => _instance ??= ServiceLocator._();

  ServiceLocator._();

  late final WebService _webService;
  late final DashboardRepository _dashboardRepository;
  late final UserRepository _userRepository;
  late final AuthRepository _authRepository;

  /// Initialize all services
  void init() {
    // Initialize WebService with your API base URL
    _webService = WebService(
      baseUrl: ApiEndpoints.baseUrl,
      timeout: AppConstants.networkTimeout,
    );

    // Initialize repositories
    _dashboardRepository = DashboardRepository(
      webService: _webService,
    );

    _userRepository = UserRepository(
        webService: _webService  // Fixed: was using webService instead of _webService
    );
    
    _authRepository = AuthRepository(
        webService: _webService
    );

    if (kDebugMode) {
      print('[ServiceLocator] Services initialized');
    }
  }

  /// Get WebService instance
  WebService get webService => _webService;

  /// Get DashboardRepository instance
  DashboardRepository get dashboardRepository => _dashboardRepository;
  UserRepository get userRepository => _userRepository;

  /// Create DashboardBloc instance
  DashboardBloc createDashboardBloc() {
    return DashboardBloc(dashboardRepository: _dashboardRepository);
  }

  UserBloc createUserBloc() {
    return UserBloc(userRepository: _userRepository);
  }
  
  AuthBloc createAuthBloc() {
    return AuthBloc(authRepository: _authRepository);
  }
}