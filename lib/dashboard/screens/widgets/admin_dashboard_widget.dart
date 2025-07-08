// admin_dashboard_widget.dart
import 'package:flutter/material.dart';
import 'package:ams/user_login/models/login.dart';
import 'package:ams/dashboard/models/dashboard_models.dart';
import 'dashboard_card_widget.dart';
import 'quick_actions_widget.dart';
import 'alerts_widget.dart';

class AdminDashboardWidget extends StatelessWidget {
  final User user;
  final DashboardOverview overview;

  const AdminDashboardWidget({
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

          // Quick actions
          QuickActionsWidget(
            actions: [
              QuickAction(
                icon: Icons.person_add,
                title: 'Add User',
                onTap: () => _navigateToAddUser(context),
              ),
              QuickAction(
                icon: Icons.add_box,
                title: 'Add Asset',
                onTap: () => _navigateToAddAsset(context),
              ),
              QuickAction(
                icon: Icons.key,
                title: 'Add License',
                onTap: () => _navigateToAddLicense(context),
              ),
              QuickAction(
                icon: Icons.business,
                title: 'Add Vendor',
                onTap: () => _navigateToAddVendor(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Alerts and notifications
          AlertsWidget(
            alerts: _buildAlerts(),
          ),
          const SizedBox(height: 24),

          // Detailed sections
          _buildDetailedSections(),
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
            colors: [Colors.deepOrange, Colors.orangeAccent],
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
              'System Administrator',
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
          'System Overview',
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
              title: 'Active Licenses',
              value: '${overview.softwareLicenseMetrics.activeLicenses}',
              subtitle: 'Used: ${overview.softwareLicenseMetrics.usedSeats}/${overview.softwareLicenseMetrics.totalSeats}',
              icon: Icons.key,
              color: Colors.green,
            ),
            DashboardCardWidget(
              title: 'Subscriptions',
              value: '${overview.subscriptionMetrics.activeSubscriptions}',
              subtitle: 'Expiring: ${overview.subscriptionMetrics.expiringSubscriptions}',
              icon: Icons.subscriptions,
              color: Colors.orange,
            ),
            DashboardCardWidget(
              title: 'Open Issues',
              value: '${overview.issueMetrics.openIssues}',
              subtitle: 'Critical: ${overview.issueMetrics.criticalIssues}',
              icon: Icons.bug_report,
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Analytics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildAssetsBreakdown(),
        const SizedBox(height: 16),
        _buildMaintenanceOverview(),
        const SizedBox(height: 16),
        _buildFinancialSummary(),
      ],
    );
  }

  Widget _buildAssetsBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assets by Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...overview.assetMetrics.assetsByCategory.entries.map(
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

  Widget _buildMaintenanceOverview() {
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

  Widget _buildFinancialSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Total Asset Value: ${overview.financialSummary.totalAssetValue}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            ...overview.financialSummary.costByCategory.entries.map(
                  (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(
                      entry.value,
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

  List<AlertItem> _buildAlerts() {
    List<AlertItem> alerts = [];

    // Assets near warranty expiry
    if (overview.assetMetrics.assetsNearWarrantyExpiry > 0) {
      alerts.add(AlertItem(
        title: 'Assets Near Warranty Expiry',
        message: '${overview.assetMetrics.assetsNearWarrantyExpiry} assets have warranties expiring soon',
        type: AlertType.warning,
        onTap: () => _navigateToAssets(),
      ));
    }

    // Expiring licenses
    if (overview.softwareLicenseMetrics.expiringLicenses > 0) {
      alerts.add(AlertItem(
        title: 'Expiring Licenses',
        message: '${overview.softwareLicenseMetrics.expiringLicenses} licenses are expiring soon',
        type: AlertType.warning,
        onTap: () => _navigateToLicenses(),
      ));
    }

    // Critical issues
    if (overview.issueMetrics.criticalIssues > 0) {
      alerts.add(AlertItem(
        title: 'Critical Issues',
        message: '${overview.issueMetrics.criticalIssues} critical issues need immediate attention',
        type: AlertType.error,
        onTap: () => _navigateToIssues(),
      ));
    }

    // Overdue maintenance
    if (overview.maintenanceMetrics.overdueMaintenance > 0) {
      alerts.add(AlertItem(
        title: 'Overdue Maintenance',
        message: '${overview.maintenanceMetrics.overdueMaintenance} maintenance tasks are overdue',
        type: AlertType.error,
        onTap: () => _navigateToMaintenance(),
      ));
    }

    return alerts;
  }

  String _formatLastUpdated(String lastUpdated) {
    // Format the last updated timestamp
    if (lastUpdated.isEmpty) return 'Unknown';
    try {
      final date = DateTime.parse(lastUpdated);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return lastUpdated;
    }
  }

  // Navigation methods
  void _navigateToAddUser(BuildContext context) {
    Navigator.of(context).pushNamed('/add-user');
  }

  void _navigateToAddAsset(BuildContext context) {
    Navigator.of(context).pushNamed('/add-asset');
  }

  void _navigateToAddLicense(BuildContext context) {
    Navigator.of(context).pushNamed('/add-license');
  }

  void _navigateToAddVendor(BuildContext context) {
    Navigator.of(context).pushNamed('/add-vendor');
  }

  void _navigateToAssets() {
    // Navigate to assets page
  }

  void _navigateToLicenses() {
    // Navigate to licenses page
  }

  void _navigateToIssues() {
    // Navigate to issues page
  }

  void _navigateToMaintenance() {
    // Navigate to maintenance page
  }
}