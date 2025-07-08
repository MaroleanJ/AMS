// dashboard_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardBloc({required this.dashboardRepository}) : super(DashboardInitial()) {
    if (kDebugMode) {
      print('[DashboardBloc] Initialized');
    }

    on<LoadDashboardOverview>(_onLoadDashboardOverview);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboardOverview(
      LoadDashboardOverview event,
      Emitter<DashboardState> emit,
      ) async {
    try {
      if (kDebugMode) {
        print('[DashboardBloc] Loading dashboard overview');
      }

      emit(DashboardLoading());

      final overview = await dashboardRepository.getDashboardOverview();

      if (kDebugMode) {
        print('[DashboardBloc] Dashboard overview loaded successfully');
      }

      emit(DashboardLoaded(overview));
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardBloc] Dashboard overview loading failed: $e');
      }

      emit(DashboardError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onRefreshDashboard(
      RefreshDashboard event,
      Emitter<DashboardState> emit,
      ) async {
    try {
      if (kDebugMode) {
        print('[DashboardBloc] Refreshing dashboard');
      }

      // If we have existing data, show refreshing state
      if (state is DashboardLoaded) {
        emit(DashboardRefreshing((state as DashboardLoaded).overview));
      } else {
        emit(DashboardLoading());
      }

      final overview = await dashboardRepository.getDashboardOverview();

      if (kDebugMode) {
        print('[DashboardBloc] Dashboard refreshed successfully');
      }

      emit(DashboardLoaded(overview));
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardBloc] Dashboard refresh failed: $e');
      }

      emit(DashboardError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}