// dashboard_event.dart
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboardOverview extends DashboardEvent {}

class LoadAssetMetrics extends DashboardEvent {}

class LoadMaintenanceMetrics extends DashboardEvent {}

class LoadLicenseMetrics extends DashboardEvent {}

class LoadSubscriptionMetrics extends DashboardEvent {}

class LoadIssueMetrics extends DashboardEvent {}

class LoadUpcomingEvents extends DashboardEvent {}

class LoadFinancialSummary extends DashboardEvent {}

class RefreshDashboard extends DashboardEvent {}