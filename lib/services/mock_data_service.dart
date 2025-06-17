import 'dart:math';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Generate mock dashboard data
  Map<String, dynamic> generateMockDashboardData() {
    final random = Random();

    // Generate random but realistic numbers
    final totalAssets = 200 + random.nextInt(100); // 200-300
    final assignedAssets = (totalAssets * 0.7).round() + random.nextInt(20);
    final availableAssets = totalAssets - assignedAssets;

    final totalLicenses = 120 + random.nextInt(60); // 120-180
    final assignedLicenses = (totalLicenses * 0.8).round() + random.nextInt(10);
    final availableLicenses = totalLicenses - assignedLicenses;
    final expiringLicenses = 8 + random.nextInt(15);

    final openIssues = random.nextInt(20) + 5;
    final resolvedIssues = 15 + random.nextInt(25);
    final assetsExpiringSoon = random.nextInt(10) + 2;

    return {
      'success': true,
      'message': 'Dashboard data retrieved successfully',
      'data': {
        'total_assets': totalAssets,
        'assigned_assets': assignedAssets,
        'available_assets': availableAssets,
        'total_licenses': totalLicenses,
        'assigned_licenses': assignedLicenses,
        'available_licenses': availableLicenses,
        'expiring_licenses': expiringLicenses,
        'open_issues': openIssues,
        'resolved_issues': resolvedIssues,
        'assets_expiring_soon': assetsExpiringSoon,
        'asset_distribution': _generateAssetDistribution(totalAssets),
        'expiring_items': _generateExpiringItems(),
        'recent_activities': _generateRecentActivities(),
      }
    };
  }

  List<Map<String, dynamic>> _generateAssetDistribution(int totalAssets) {
    final categories = [
      {'name': 'Laptops', 'percentage': 35.0},
      {'name': 'Desktops', 'percentage': 25.0},
      {'name': 'Mobile Devices', 'percentage': 18.0},
      {'name': 'Servers', 'percentage': 12.0},
      {'name': 'Network Equipment', 'percentage': 10.0},
    ];

    return categories.map((category) {
      final count = (totalAssets * (category['percentage'] as double) / 100).round();
      return {
        'category': category['name'],
        'count': count,
        'percentage': category['percentage'],
      };
    }).toList();
  }

  List<Map<String, dynamic>> _generateExpiringItems() {
    final assetNames = [
      'MacBook Pro 2019', 'Dell OptiPlex 7090', 'HP EliteBook 840',
      'Lenovo ThinkPad X1', 'Surface Pro 8', 'iMac 24-inch',
      'HP Pavilion Desktop', 'ASUS ZenBook', 'Acer Aspire 5'
    ];

    final licenseNames = [
      'Adobe Creative Suite', 'Microsoft Office 365', 'AutoCAD License',
      'Visual Studio Professional', 'Slack Premium', 'Zoom Pro',
      'Photoshop License', 'Windows 11 Pro', 'Antivirus Enterprise'
    ];

    final random = Random();
    final expiringItems = <Map<String, dynamic>>[];

    // Generate 5-10 expiring items
    final itemCount = 5 + random.nextInt(6);

    for (int i = 0; i < itemCount; i++) {
      final isAsset = random.nextBool();
      final daysUntilExpiry = 1 + random.nextInt(30); // 1-30 days
      final expiryDate = DateTime.now().add(Duration(days: daysUntilExpiry));

      expiringItems.add({
        'id': i + 1,
        'name': isAsset
            ? assetNames[random.nextInt(assetNames.length)]
            : licenseNames[random.nextInt(licenseNames.length)],
        'type': isAsset ? 'asset' : 'license',
        'expiry_date': expiryDate.toIso8601String().split('T')[0],
        'days_until_expiry': daysUntilExpiry,
      });
    }

    // Sort by days until expiry (most urgent first)
    expiringItems.sort((a, b) =>
        (a['days_until_expiry'] as int).compareTo(b['days_until_expiry'] as int));

    return expiringItems;
  }

  List<Map<String, dynamic>> _generateRecentActivities() {
    final actions = ['assigned', 'returned', 'created', 'resolved', 'updated', 'expired'];
    final itemNames = [
      'MacBook Air M2', 'iPad Pro 12.9"', 'Dell Monitor 27"',
      'Logitech Mouse', 'Keyboard Wireless', 'iPhone 14 Pro',
      'Surface Book 3', 'HP Printer', 'Network Switch', 'Router'
    ];
    final userNames = [
      'John Doe', 'Sarah Wilson', 'Mike Johnson', 'Emily Davis',
      'Robert Brown', 'Lisa Anderson', 'David Miller', 'Anna Garcia'
    ];
    final types = ['asset', 'license', 'issue'];

    final random = Random();
    final activities = <Map<String, dynamic>>[];

    // Generate 8-15 recent activities
    final activityCount = 8 + random.nextInt(8);

    for (int i = 0; i < activityCount; i++) {
      final timestamp = DateTime.now().subtract(
          Duration(
              hours: random.nextInt(72), // Last 3 days
              minutes: random.nextInt(60)
          )
      );

      final action = actions[random.nextInt(actions.length)];
      final type = types[random.nextInt(types.length)];

      String itemName;
      if (type == 'issue') {
        itemName = 'Issue #${100 + random.nextInt(50)}';
      } else {
        itemName = itemNames[random.nextInt(itemNames.length)];
      }

      activities.add({
        'action': action,
        'item_name': itemName,
        'user_name': userNames[random.nextInt(userNames.length)],
        'timestamp': timestamp.toIso8601String(),
        'type': type,
      });
    }

    // Sort by timestamp (most recent first)
    activities.sort((a, b) =>
        DateTime.parse(b['timestamp'] as String)
            .compareTo(DateTime.parse(a['timestamp'] as String)));

    return activities;
  }
}