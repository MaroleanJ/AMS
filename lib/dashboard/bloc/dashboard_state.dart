import 'package:equatable/equatable.dart';
import '../models/dashboard_summary.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardSummary summary;
  const DashboardLoaded(this.summary);
  @override
  List<Object?> get props => [summary];
}

class DashboardError extends DashboardState {
  final String error;
  const DashboardError(this.error);
  @override
  List<Object?> get props => [error];
}

class DashboardRefreshing extends DashboardState {
  final DashboardSummary currentSummary;
  const DashboardRefreshing(this.currentSummary);
  @override
  List<Object?> get props => [currentSummary];
}