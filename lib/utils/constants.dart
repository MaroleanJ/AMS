class ApiEndpoints {
  // Base URL - replace with your actual API base URL
  static const String baseUrl = 'https://your-api-domain.com/api/';

  // Dashboard endpoints
  static const String dashboardSummary = 'dashboard/summary';

  // Asset endpoints
  static const String assets = 'assets';
  static const String addAsset = 'assets/create';
  static const String updateAsset = 'assets/update';
  static const String deleteAsset = 'assets/delete';

  // License endpoints
  static const String licenses = 'licenses';
  static const String addLicense = 'licenses/create';
  static const String updateLicense = 'licenses/update';
  static const String deleteLicense = 'licenses/delete';

  // User endpoints
  static const String users = 'users';
  static const String addUser = 'users/create';
  static const String updateUser = 'users/update';
  static const String deleteUser = 'users/delete';

  // Issue endpoints
  static const String issues = 'issues';
  static const String reportIssue = 'issues/create';
  static const String updateIssue = 'issues/update';
  static const String resolveIssue = 'issues/resolve';
}

class AppConstants {
  // App configuration
  static const String appName = 'Asset Management Dashboard';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration refreshInterval = Duration(minutes: 5);

  // UI Constants
  static const double cardElevation = 2.0;
  static const double borderRadius = 8.0;
  static const double defaultPadding = 16.0;

  // Asset Categories
  static const List<String> assetCategories = [
    'Laptops',
    'Desktops',
    'Monitors',
    'Keyboards',
    'Mice',
    'Printers',
    'Mobile Devices',
    'Tablets',
    'Servers',
    'Network Equipment',
    'Other',
  ];

  // Asset Status
  static const List<String> assetStatuses = [
    'Available',
    'Assigned',
    'In Repair',
    'Retired',
    'Lost',
  ];

  // License Types
  static const List<String> licenseTypes = [
    'Software',
    'Operating System',
    'Antivirus',
    'Office Suite',
    'Development Tools',
    'Design Software',
    'Other',
  ];

  // Issue Priorities
  static const List<String> issuePriorities = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  // Issue Types
  static const List<String> issueTypes = [
    'Hardware',
    'Software',
    'Network',
    'Security',
    'Other',
  ];
}