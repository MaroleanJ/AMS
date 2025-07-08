// dashboard_state.dart
import 'package:equatable/equatable.dart';
import 'package:ams/dashboard/models/dashboard_models.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardOverview overview;

  const DashboardLoaded(this.overview);

  @override
  List<Object?> get props => [overview];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardRefreshing extends DashboardState {
  final DashboardOverview overview;

  const DashboardRefreshing(this.overview);

  @override
  List<Object?> get props => [overview];
}