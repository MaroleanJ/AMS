import 'package:flutter/foundation.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../dashboard/repositories/dashboard_repository.dart';
import 'mock_data_service.dart';
import 'web_service.dart';
import '../utils/constants.dart';

class ServiceLocator {
  static ServiceLocator? _instance;
  static ServiceLocator get instance => _instance ??= ServiceLocator._();

  ServiceLocator._();

  late final WebService _webService;
  late final DashboardRepository _dashboardRepository;

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
      mockDataService: MockDataService(),
      useMockData: true,
    );
    if (kDebugMode) {
      print('[ServiceLocator] Services initialized');
    }
  }

  /// Get WebService instance
  WebService get webService => _webService;

  /// Get DashboardRepository instance
  DashboardRepository get dashboardRepository => _dashboardRepository;

  /// Create DashboardBloc instance
  DashboardBloc createDashboardBloc() {
    return DashboardBloc(dashboardRepository: _dashboardRepository);
  }
}