import 'package:flutter/material.dart';
import 'package:ams/user_login/models/login.dart';
import 'package:ams/dashboard/models/dashboard_models.dart';
import 'dashboard_card_widget.dart';
import 'quick_actions_widget.dart';
import 'alerts_widget.dart';

class EmployeeDashboardWidget extends StatelessWidget {
  final User user;
  final DashboardOverview overview;

  const EmployeeDashboardWidget({
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

          // My assignments overview
          _buildMyAssignments(),
          const SizedBox(height: 24),

          // Quick actions (limited for Employee)
          QuickActionsWidget(
            actions: [
              QuickAction(
                icon: Icons.report_problem,
                title: 'Report Issue',
                onTap: () => _navigateToReportIssue(context),
              ),
              QuickAction(
                icon: Icons.history,
                title: 'My History',
                onTap: () => _navigateToMyHistory(context),
              ),
              QuickAction(
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () => _navigateToHelp(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // My alerts
          AlertsWidget(
            alerts: _buildMyAlerts(),
          ),
          const SizedBox(height: 24),

          // My asset details
          _buildMyAssetDetails(),
          const SizedBox(height: 24),

          // My license details
          _buildMyLicenseDetails(),
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
            colors: [Colors.green, Colors.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.firstName}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Employee Dashboard',
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

  Widget _buildMyAssignments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Assignments',
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
              title: 'My Assets',
              value: '${_getMyAssetsCount()}',
              subtitle: 'Active assignments',
              icon: Icons.devices,
              color: Colors.blue,
            ),
            DashboardCardWidget(
              title: 'My Licenses',
              value: '${_getMyLicensesCount()}',
              subtitle: 'Software licenses',
              icon: Icons.key,
              color: Colors.green,
            ),
            DashboardCardWidget(
              title: 'Pending Issues',
              value: '${_getMyPendingIssues()}',
              subtitle: 'Reported by me',
              icon: Icons.bug_report,
              color: Colors.orange,
            ),
            DashboardCardWidget(
              title: 'Maintenance',
              value: '${_getMyMaintenanceCount()}',
              subtitle: 'Due this month',
              icon: Icons.build,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMyAssetDetails() {
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
                  'My Assets',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => print('ViewAll'),//_navigateToMyAssets(context),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAssetItem(
              'Dell Laptop',
              'DL001',
              'Good condition',
              Icons.laptop,
              Colors.green,
            ),
            _buildAssetItem(
              'Wireless Mouse',
              'WM001',
              'Excellent condition',
              Icons.mouse,
              Colors.green,
            ),
            _buildAssetItem(
              'Monitor',
              'MON001',
              'Fair condition',
              Icons.monitor,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetItem(String name, String code, String status, IconData icon, Color statusColor) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(name),
      subtitle: Text(code),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMyLicenseDetails() {
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
                  'My Software Licenses',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => print('ViewAll'), //_navigateToMyLicenses(context),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildLicenseItem(
              'Microsoft Office 365',
              'Expires: Dec 2024',
              Icons.description,
              Colors.blue,
            ),
            _buildLicenseItem(
              'Adobe Creative Suite',
              'Expires: Jan 2025',
              Icons.design_services,
              Colors.red,
            ),
            _buildLicenseItem(
              'Slack Pro',
              'Expires: Mar 2025',
              Icons.chat,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseItem(String name, String expiry, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(name),
      subtitle: Text(expiry),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  List<AlertItem> _buildMyAlerts() {
    List<AlertItem> alerts = [];

    // Sample alerts for employee
    alerts.add(AlertItem(
      title: 'Asset Maintenance Due',
      message: 'Your laptop is due for maintenance this week',
      type: AlertType.info,
      onTap: () => print('My Assets'), //_navigateToMyAssets(context),
    ));

    alerts.add(AlertItem(
      title: 'License Expiring Soon',
      message: 'Your Microsoft Office license expires in 30 days',
      type: AlertType.warning,
      onTap: () => print('My Licenses'),//_navigateToMyLicenses(context),
    ));

    return alerts;
  }

  // Helper methods to get employee-specific data
  int _getMyAssetsCount() {
    // This would typically come from user-specific data
    return 3;
  }

  int _getMyLicensesCount() {
    // This would typically come from user-specific data
    return 3;
  }

  int _getMyPendingIssues() {
    // This would typically come from user-specific data
    return 1;
  }

  int _getMyMaintenanceCount() {
    // This would typically come from user-specific data
    return 1;
  }

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
  void _navigateToReportIssue(BuildContext context) {
    Navigator.of(context).pushNamed('/report-issue');
  }

  void _navigateToMyHistory(BuildContext context) {
    Navigator.of(context).pushNamed('/my-history');
  }

  void _navigateToHelp(BuildContext context) {
    Navigator.of(context).pushNamed('/help');
  }

  void _navigateToMyAssets(BuildContext context) {
    Navigator.of(context).pushNamed('/my-assets');
  }

  void _navigateToMyLicenses(BuildContext context) {
    Navigator.of(context).pushNamed('/my-licenses');
  }
}