import 'package:flutter/material.dart';
import 'package:ams/user_login/models/login.dart';
import 'package:ams/dashboard/models/dashboard_models.dart';
import 'dashboard_card_widget.dart';
import 'quick_actions_widget.dart';
import 'alerts_widget.dart';

class AssetManagerDashboardWidget extends StatelessWidget {
  final User user;
  final DashboardOverview overview;

  const AssetManagerDashboardWidget({
    Key? key,
    required this.user,
    required this.overview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          _buildWelcomeSection(),
          const SizedBox(height: 24),

          // Key metrics overview
          _buildKeyMetrics(),
          const SizedBox(height: 24),

          // Quick actions (limited for Asset Manager)
          QuickActionsWidget(
            actions: [
              QuickAction(
                icon: Icons.add_box,
                title: 'Add Asset',
                onTap: () => _navigateToAddAsset(context),
              ),
              QuickAction(
                icon: Icons.assignment,
                title: 'Assign Asset',
                onTap: () => _navigateToAssignAsset(context),
              ),
              QuickAction(
                icon: Icons.report_problem,
                title: 'Report Issue',
                onTap: () => _navigateToReportIssue(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Alerts and notifications
          AlertsWidget(
            alerts: _buildAlerts(),
          ),
          const SizedBox(height: 24),

          // Asset management sections
          _buildAssetManagementSections(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${user.firstName}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Asset Manager',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: ${_formatLastUpdated(overview.lastUpdated)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Asset Management Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            DashboardCardWidget(
              title: 'Total Assets',
              value: '${overview.assetMetrics.totalAssets}',
              subtitle: 'Available: ${overview.assetMetrics.assetsByStatus['available'] ?? 0}',
              icon: Icons.inventory,
              color: Colors.blue,
            ),
            DashboardCardWidget(
              title: 'License Usage',
              value: '${overview.softwareLicenseMetrics.licenseUtilization}',
              subtitle: 'Used: ${overview.softwareLicenseMetrics.usedSeats}/${overview.softwareLicenseMetrics.totalSeats}',
              icon: Icons.key,
              color: Colors.green,
            ),
            DashboardCardWidget(
              title: 'Open Issues',
              value: '${overview.issueMetrics.openIssues}',
              subtitle: 'Critical: ${overview.issueMetrics.criticalIssues}',
              icon: Icons.bug_report,
              color: Colors.red,
            ),
            DashboardCardWidget(
              title: 'Maintenance',
              value: '${overview.maintenanceMetrics.pendingMaintenance}',
              subtitle: 'Overdue: ${overview.maintenanceMetrics.overdueMaintenance}',
              icon: Icons.build,
              color: Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAssetManagementSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Asset Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildRecentAssets(),
        const SizedBox(height: 16),
        _buildAssetsByLocation(),
        const SizedBox(height: 16),
        _buildMaintenanceStatus(),
      ],
    );
  }

  Widget _buildRecentAssets() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recently Added Assets',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => print('Assets'), //_navigateToAssets(context),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // This would typically show recent assets from API
            const ListTile(
              leading: Icon(Icons.laptop, color: Colors.blue),
              title: Text('Dell Laptop - DL001'),
              subtitle: Text('Added 2 hours ago'),
            ),
            const ListTile(
              leading: Icon(Icons.phone_android, color: Colors.green),
              title: Text('iPhone 14 - IP001'),
              subtitle: Text('Added 5 hours ago'),
            ),
            const ListTile(
              leading: Icon(Icons.print, color: Colors.orange),
              title: Text('HP Printer - HP001'),
              subtitle: Text('Added 1 day ago'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetsByLocation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assets by Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...overview.assetMetrics.assetsByLocation.entries.map(
                  (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(
                      '${entry.value}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Maintenance Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMaintenanceItem(
                  'Pending',
                  '${overview.maintenanceMetrics.pendingMaintenance}',
                  Colors.orange,
                ),
                _buildMaintenanceItem(
                  'Overdue',
                  '${overview.maintenanceMetrics.overdueMaintenance}',
                  Colors.red,
                ),
                _buildMaintenanceItem(
                  'This Month',
                  '${overview.maintenanceMetrics.maintenanceThisMonth}',
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  List<AlertItem> _buildAlerts() {
    List<AlertItem> alerts = [];

    // Assets near warranty expiry
    if (overview.assetMetrics.assetsNearWarrantyExpiry > 0) {
      alerts.add(AlertItem(
        title: 'Assets Near Warranty Expiry',
        message: '${overview.assetMetrics.assetsNearWarrantyExpiry} assets have warranties expiring soon',
        type: AlertType.warning,
        onTap: () => print('Assets'), //_navigateToAssets(context),
      ));
    }

    // Expiring licenses
    if (overview.softwareLicenseMetrics.expiringLicenses > 0) {
      alerts.add(AlertItem(
        title: 'Expiring Licenses',
        message: '${overview.softwareLicenseMetrics.expiringLicenses} licenses are expiring soon',
        type: AlertType.warning,
        onTap: () => print('Licenses'), //_navigateToLicenses(context),
      ));
    }

    // Overdue maintenance
    if (overview.maintenanceMetrics.overdueMaintenance > 0) {
      alerts.add(AlertItem(
        title: 'Overdue Maintenance',
        message: '${overview.maintenanceMetrics.overdueMaintenance} maintenance tasks are overdue',
        type: AlertType.error,
        onTap: () => print('Maintenance') //_navigateToMaintenance(context),
      ));
    }

    // Critical issues
    if (overview.issueMetrics.criticalIssues > 0) {
      alerts.add(AlertItem(
        title: 'Critical Issues',
        message: '${overview.issueMetrics.criticalIssues} critical issues require immediate attention',
        type: AlertType.error,
        onTap: () => print('issues') //_navigateToIssues(context),
      ));
    }

    // Unassigned assets
    if (overview.assetMetrics.unassignedAssets > 0) {
      alerts.add(AlertItem(
        title: 'Unassigned Assets',
        message: '${overview.assetMetrics.unassignedAssets} assets are not assigned to anyone',
        type: AlertType.info,
        onTap: () => print('Assets') //_navigateToAssets(context),
      ));
    }

    return alerts;
  }

  // Helper method to format last updated date
  String _formatLastUpdated(String lastUpdated) {
    if (lastUpdated.isEmpty) return 'Unknown';
    try {
      final date = DateTime.parse(lastUpdated);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return lastUpdated;
    }
  }

  // Navigation methods
  void _navigateToAddAsset(BuildContext context) {
    Navigator.of(context).pushNamed('/add-asset');
  }

  void _navigateToAssignAsset(BuildContext context) {
    Navigator.of(context).pushNamed('/assign-asset');
  }

  void _navigateToReportIssue(BuildContext context) {
    Navigator.of(context).pushNamed('/report-issue');
  }

  void _navigateToAssets(BuildContext context) {
    Navigator.of(context).pushNamed('/assets');
  }

  void _navigateToLicenses(BuildContext context) {
    Navigator.of(context).pushNamed('/licenses');
  }

  void _navigateToMaintenance(BuildContext context) {
    Navigator.of(context).pushNamed('/maintenance');
  }

  void _navigateToIssues(BuildContext context) {
    Navigator.of(context).pushNamed('/issues');
  }
}