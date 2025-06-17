import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../models/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;
  late DashboardSummary _currentSummary;

  DashboardBloc({required this.dashboardRepository}) : super(DashboardLoading()) {
    if (kDebugMode) {
      print("[DashboardBloc] Initialized.");
    }
    on<LoadDashboardSummary>(_onLoadDashboardSummary);
    on<RefreshDashboard>(_onRefreshDashboard);
    add(LoadDashboardSummary());
  }

  Future<void> _onLoadDashboardSummary(LoadDashboardSummary event, Emitter<DashboardState> emit) async {
    try {
      if (kDebugMode) {
        print("[DashboardBloc] Processing LoadDashboardSummary event");
      }
      emit(DashboardLoading());
      _currentSummary = (await dashboardRepository.fetchDashboardSummary()) as DashboardSummary;

      if (kDebugMode) {
        print("[DashboardBloc] Emitting DashboardLoaded");
      }
      emit(DashboardLoaded(_currentSummary!));
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print("[DashboardBloc] Error loading dashboard: $e");
        print("[DashboardBloc] Stacktrace: $stacktrace");
      }
      emit(DashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshDashboard(RefreshDashboard event, Emitter<DashboardState> emit) async {
    try {
      if (_currentSummary != null) {
        emit(DashboardRefreshing(_currentSummary!));
      }

      _currentSummary = (await dashboardRepository.fetchDashboardSummary()) as DashboardSummary;
      emit(DashboardLoaded(_currentSummary!));
    } catch (e) {
      if (kDebugMode) {
        print("[DashboardBloc] Error refreshing dashboard: $e");
      }
      emit(DashboardError('Failed to refresh dashboard: ${e.toString()}'));
    }
  }
}
