import 'package:equatable/equatable.dart';

class DashboardSummary extends Equatable {
  final int totalAssets;
  final int assignedAssets;
  final int availableAssets;
  final int totalLicenses;
  final int assignedLicenses;
  final int availableLicenses;
  final int expiringLicenses;
  final int openIssues;
  final int resolvedIssues;
  final int assetsExpiringSoon;
  final List<AssetCategoryDistribution> assetDistribution;
  final List<ExpiringItem> expiringItems;
  final List<RecentActivity> recentActivities;

  const DashboardSummary({
    required this.totalAssets,
    required this.assignedAssets,
    required this.availableAssets,
    required this.totalLicenses,
    required this.assignedLicenses,
    required this.availableLicenses,
    required this.expiringLicenses,
    required this.openIssues,
    required this.resolvedIssues,
    required this.assetsExpiringSoon,
    required this.assetDistribution,
    required this.expiringItems,
    required this.recentActivities,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalAssets: json['total_assets'] ?? 0,
      assignedAssets: json['assigned_assets'] ?? 0,
      availableAssets: json['available_assets'] ?? 0,
      totalLicenses: json['total_licenses'] ?? 0,
      assignedLicenses: json['assigned_licenses'] ?? 0,
      availableLicenses: json['available_licenses'] ?? 0,
      expiringLicenses: json['expiring_licenses'] ?? 0,
      openIssues: json['open_issues'] ?? 0,
      resolvedIssues: json['resolved_issues'] ?? 0,
      assetsExpiringSoon: json['assets_expiring_soon'] ?? 0,
      assetDistribution: (json['asset_distribution'] as List<dynamic>?)
          ?.map((item) => AssetCategoryDistribution.fromJson(item))
          .toList() ?? [],
      expiringItems: (json['expiring_items'] as List<dynamic>?)
          ?.map((item) => ExpiringItem.fromJson(item))
          .toList() ?? [],
      recentActivities: (json['recent_activities'] as List<dynamic>?)
          ?.map((item) => RecentActivity.fromJson(item))
          .toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [
    totalAssets, assignedAssets, availableAssets,
    totalLicenses, assignedLicenses, availableLicenses, expiringLicenses,
    openIssues, resolvedIssues, assetsExpiringSoon,
    assetDistribution, expiringItems, recentActivities
  ];
}

class AssetCategoryDistribution extends Equatable {
  final String category;
  final int count;
  final double percentage;

  const AssetCategoryDistribution({
    required this.category,
    required this.count,
    required this.percentage,
  });

  factory AssetCategoryDistribution.fromJson(Map<String, dynamic> json) {
    return AssetCategoryDistribution(
      category: json['category'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [category, count, percentage];
}

class ExpiringItem extends Equatable {
  final int id;
  final String name;
  final String type; // 'asset' or 'license'
  final String expiryDate;
  final int daysUntilExpiry;

  const ExpiringItem({
    required this.id,
    required this.name,
    required this.type,
    required this.expiryDate,
    required this.daysUntilExpiry,
  });

  factory ExpiringItem.fromJson(Map<String, dynamic> json) {
    return ExpiringItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      daysUntilExpiry: json['days_until_expiry'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, type, expiryDate, daysUntilExpiry];
}

class RecentActivity extends Equatable {
  final String action;
  final String itemName;
  final String userName;
  final String timestamp;
  final String type;

  const RecentActivity({
    required this.action,
    required this.itemName,
    required this.userName,
    required this.timestamp,
    required this.type,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      action: json['action'] ?? '',
      itemName: json['item_name'] ?? '',
      userName: json['user_name'] ?? '',
      timestamp: json['timestamp'] ?? '',
      type: json['type'] ?? '',
    );
  }

  @override
  List<Object?> get props => [action, itemName, userName, timestamp, type];
}
