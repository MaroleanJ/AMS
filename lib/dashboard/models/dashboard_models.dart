// dashboard_models.dart
import 'package:equatable/equatable.dart';

class DashboardOverview extends Equatable {
  final AssetMetrics assetMetrics;
  final MaintenanceMetrics maintenanceMetrics;
  final SoftwareLicenseMetrics softwareLicenseMetrics;
  final SubscriptionMetrics subscriptionMetrics;
  final IssueMetrics issueMetrics;
  final UpcomingEvents upcomingEvents;
  final FinancialSummary financialSummary;
  final String lastUpdated;

  const DashboardOverview({
    required this.assetMetrics,
    required this.maintenanceMetrics,
    required this.softwareLicenseMetrics,
    required this.subscriptionMetrics,
    required this.issueMetrics,
    required this.upcomingEvents,
    required this.financialSummary,
    required this.lastUpdated,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      assetMetrics: AssetMetrics.fromJson(json['assetMetrics'] ?? {}),
      maintenanceMetrics: MaintenanceMetrics.fromJson(json['maintenanceMetrics'] ?? {}),
      softwareLicenseMetrics: SoftwareLicenseMetrics.fromJson(json['softwareLicenseMetrics'] ?? {}),
      subscriptionMetrics: SubscriptionMetrics.fromJson(json['subscriptionMetrics'] ?? {}),
      issueMetrics: IssueMetrics.fromJson(json['issueMetrics'] ?? {}),
      upcomingEvents: UpcomingEvents.fromJson(json['upcomingEvents'] ?? {}),
      financialSummary: FinancialSummary.fromJson(json['financialSummary'] ?? {}),
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    assetMetrics,
    maintenanceMetrics,
    softwareLicenseMetrics,
    subscriptionMetrics,
    issueMetrics,
    upcomingEvents,
    financialSummary,
    lastUpdated,
  ];
}

class AssetMetrics extends Equatable {
  final int totalAssets;
  final Map<String, int> assetsByStatus;
  final Map<String, int> assetsByCategory;
  final Map<String, int> assetsByLocation;
  final String totalValue;
  final String avgAssetAge;
  final int assetsNearWarrantyExpiry;
  final int unassignedAssets;

  const AssetMetrics({
    required this.totalAssets,
    required this.assetsByStatus,
    required this.assetsByCategory,
    required this.assetsByLocation,
    required this.totalValue,
    required this.avgAssetAge,
    required this.assetsNearWarrantyExpiry,
    required this.unassignedAssets,
  });

  factory AssetMetrics.fromJson(Map<String, dynamic> json) {
    return AssetMetrics(
      totalAssets: json['totalAssets'] ?? 0,
      assetsByStatus: Map<String, int>.from(json['assetsByStatus'] ?? {}),
      assetsByCategory: Map<String, int>.from(json['assetsByCategory'] ?? {}),
      assetsByLocation: Map<String, int>.from(json['assetsByLocation'] ?? {}),
      totalValue: json['totalValue'] ?? '0.00',
      avgAssetAge: json['avgAssetAge'] ?? '0 years',
      assetsNearWarrantyExpiry: json['assetsNearWarrantyExpiry'] ?? 0,
      unassignedAssets: json['unassignedAssets'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    totalAssets,
    assetsByStatus,
    assetsByCategory,
    assetsByLocation,
    totalValue,
    avgAssetAge,
    assetsNearWarrantyExpiry,
    unassignedAssets,
  ];
}

class MaintenanceMetrics extends Equatable {
  final int totalMaintenanceRecords;
  final int maintenanceThisMonth;
  final int pendingMaintenance;
  final int overdueMaintenance;
  final Map<String, int> maintenanceByType;
  final Map<String, int> maintenanceByStatus;
  final List<String> topMaintenanceAssets;

  const MaintenanceMetrics({
    required this.totalMaintenanceRecords,
    required this.maintenanceThisMonth,
    required this.pendingMaintenance,
    required this.overdueMaintenance,
    required this.maintenanceByType,
    required this.maintenanceByStatus,
    required this.topMaintenanceAssets,
  });

  factory MaintenanceMetrics.fromJson(Map<String, dynamic> json) {
    return MaintenanceMetrics(
      totalMaintenanceRecords: json['totalMaintenanceRecords'] ?? 0,
      maintenanceThisMonth: json['maintenanceThisMonth'] ?? 0,
      pendingMaintenance: json['pendingMaintenance'] ?? 0,
      overdueMaintenance: json['overdueMaintenance'] ?? 0,
      maintenanceByType: Map<String, int>.from(json['maintenanceByType'] ?? {}),
      maintenanceByStatus: Map<String, int>.from(json['maintenanceByStatus'] ?? {}),
      topMaintenanceAssets: List<String>.from(json['topMaintenanceAssets'] ?? []),
    );
  }

  @override
  List<Object?> get props => [
    totalMaintenanceRecords,
    maintenanceThisMonth,
    pendingMaintenance,
    overdueMaintenance,
    maintenanceByType,
    maintenanceByStatus,
    topMaintenanceAssets,
  ];
}

class SoftwareLicenseMetrics extends Equatable {
  final int totalLicenses;
  final int activeLicenses;
  final int expiredLicenses;
  final int expiringLicenses;
  final String licenseUtilization;
  final int totalSeats;
  final int usedSeats;
  final Map<String, int> licensesByVendor;

  const SoftwareLicenseMetrics({
    required this.totalLicenses,
    required this.activeLicenses,
    required this.expiredLicenses,
    required this.expiringLicenses,
    required this.licenseUtilization,
    required this.totalSeats,
    required this.usedSeats,
    required this.licensesByVendor,
  });

  factory SoftwareLicenseMetrics.fromJson(Map<String, dynamic> json) {
    return SoftwareLicenseMetrics(
      totalLicenses: json['totalLicenses'] ?? 0,
      activeLicenses: json['activeLicenses'] ?? 0,
      expiredLicenses: json['expiredLicenses'] ?? 0,
      expiringLicenses: json['expiringLicenses'] ?? 0,
      licenseUtilization: json['licenseUtilization'] ?? '0%',
      totalSeats: json['totalSeats'] ?? 0,
      usedSeats: json['usedSeats'] ?? 0,
      licensesByVendor: Map<String, int>.from(json['licensesByVendor'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [
    totalLicenses,
    activeLicenses,
    expiredLicenses,
    expiringLicenses,
    licenseUtilization,
    totalSeats,
    usedSeats,
    licensesByVendor,
  ];
}

class SubscriptionMetrics extends Equatable {
  final int totalSubscriptions;
  final int activeSubscriptions;
  final int expiredSubscriptions;
  final int expiringSubscriptions;
  final Map<String, int> subscriptionsByVendor;

  const SubscriptionMetrics({
    required this.totalSubscriptions,
    required this.activeSubscriptions,
    required this.expiredSubscriptions,
    required this.expiringSubscriptions,
    required this.subscriptionsByVendor,
  });

  factory SubscriptionMetrics.fromJson(Map<String, dynamic> json) {
    return SubscriptionMetrics(
      totalSubscriptions: json['totalSubscriptions'] ?? 0,
      activeSubscriptions: json['activeSubscriptions'] ?? 0,
      expiredSubscriptions: json['expiredSubscriptions'] ?? 0,
      expiringSubscriptions: json['expiringSubscriptions'] ?? 0,
      subscriptionsByVendor: Map<String, int>.from(json['subscriptionsByVendor'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [
    totalSubscriptions,
    activeSubscriptions,
    expiredSubscriptions,
    expiringSubscriptions,
    subscriptionsByVendor,
  ];
}

class IssueMetrics extends Equatable {
  final int totalIssues;
  final int openIssues;
  final int resolvedIssues;
  final int criticalIssues;
  final Map<String, int> issuesByType;
  final Map<String, int> issuesBySeverity;
  final int issuesThisMonth;

  const IssueMetrics({
    required this.totalIssues,
    required this.openIssues,
    required this.resolvedIssues,
    required this.criticalIssues,
    required this.issuesByType,
    required this.issuesBySeverity,
    required this.issuesThisMonth,
  });

  factory IssueMetrics.fromJson(Map<String, dynamic> json) {
    return IssueMetrics(
      totalIssues: json['totalIssues'] ?? 0,
      openIssues: json['openIssues'] ?? 0,
      resolvedIssues: json['resolvedIssues'] ?? 0,
      criticalIssues: json['criticalIssues'] ?? 0,
      issuesByType: Map<String, int>.from(json['issuesByType'] ?? {}),
      issuesBySeverity: Map<String, int>.from(json['issuesBySeverity'] ?? {}),
      issuesThisMonth: json['issuesThisMonth'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    totalIssues,
    openIssues,
    resolvedIssues,
    criticalIssues,
    issuesByType,
    issuesBySeverity,
    issuesThisMonth,
  ];
}

class UpcomingEvents extends Equatable {
  final List<String> maintenanceDue;
  final List<String> licenseExpiring;
  final List<String> subscriptionExpiring;
  final List<String> warrantyExpiring;

  const UpcomingEvents({
    required this.maintenanceDue,
    required this.licenseExpiring,
    required this.subscriptionExpiring,
    required this.warrantyExpiring,
  });

  factory UpcomingEvents.fromJson(Map<String, dynamic> json) {
    return UpcomingEvents(
      maintenanceDue: List<String>.from(json['maintenanceDue'] ?? []),
      licenseExpiring: List<String>.from(json['licenseExpiring'] ?? []),
      subscriptionExpiring: List<String>.from(json['subscriptionExpiring'] ?? []),
      warrantyExpiring: List<String>.from(json['warrantyExpiring'] ?? []),
    );
  }

  @override
  List<Object?> get props => [
    maintenanceDue,
    licenseExpiring,
    subscriptionExpiring,
    warrantyExpiring,
  ];
}

class FinancialSummary extends Equatable {
  final String totalAssetValue;
  final Map<String, String> costByCategory;

  const FinancialSummary({
    required this.totalAssetValue,
    required this.costByCategory,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      totalAssetValue: json['totalAssetValue'] ?? '0.00',
      costByCategory: Map<String, String>.from(json['costByCategory'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [totalAssetValue, costByCategory];
}