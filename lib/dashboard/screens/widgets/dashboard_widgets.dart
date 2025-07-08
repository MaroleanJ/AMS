import 'package:flutter/material.dart';
import '../../models/dashboard_models.dart';
import 'package:ams/services/common_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AdminDashboardCards extends StatelessWidget {
  final DashboardOverview overview;

  const AdminDashboardCards({Key? key, required this.overview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DashboardCard(
          title: 'Total Assets',
          value: overview.assetMetrics.totalAssets.toString(),
          subtitle: 'Avg age: ${overview.assetMetrics.avgAssetAge}',
          icon: Icons.inventory,
          color: Colors.blue,
        ),
        DashboardCard(
          title: 'Total Value',
          value: '₹${overview.assetMetrics.totalValue}',
          subtitle: 'Asset value',
          icon: Icons.monetization_on,
          color: Colors.green,
        ),
        DashboardCard(
          title: 'Active Licenses',
          value: overview.softwareLicenseMetrics.activeLicenses.toString(),
          subtitle: 'Utilization: ${overview.softwareLicenseMetrics.licenseUtilization}',
          icon: Icons.verified_user,
          color: Colors.orange,
        ),
        DashboardCard(
          title: 'Open Issues',
          value: overview.issueMetrics.openIssues.toString(),
          subtitle: 'Critical: ${overview.issueMetrics.criticalIssues}',
          icon: Icons.error_outline,
          color: Colors.red,
        ),
        DashboardCard(
          title: 'Subscriptions',
          value: overview.subscriptionMetrics.activeSubscriptions.toString(),
          subtitle: 'Expiring: ${overview.subscriptionMetrics.expiringSubscriptions}',
          icon: Icons.subscriptions,
          color: Colors.purple,
        ),
        DashboardCard(
          title: 'Maintenance',
          value: overview.maintenanceMetrics.pendingMaintenance.toString(),
          subtitle: 'Overdue: ${overview.maintenanceMetrics.overdueMaintenance}',
          icon: Icons.build,
          color: Colors.teal,
        ),
      ],
    );
  }
}

class AssetManagerDashboardCards extends StatelessWidget {
  final DashboardOverview overview;

  const AssetManagerDashboardCards({Key? key, required this.overview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DashboardCard(
          title: 'Total Assets',
          value: overview.assetMetrics.totalAssets.toString(),
          subtitle: 'Unassigned: ${overview.assetMetrics.unassignedAssets}',
          icon: Icons.inventory,
          color: Colors.blue,
        ),
        DashboardCard(
          title: 'Asset Value',
          value: '₹${overview.assetMetrics.totalValue}',
          subtitle: 'Total value',
          icon: Icons.monetization_on,
          color: Colors.green,
        ),
        DashboardCard(
          title: 'Active Licenses',
          value: overview.softwareLicenseMetrics.activeLicenses.toString(),
          subtitle: 'Seats: ${overview.softwareLicenseMetrics.usedSeats}/${overview.softwareLicenseMetrics.totalSeats}',
          icon: Icons.verified_user,
          color: Colors.orange,
        ),
        DashboardCard(
          title: 'Open Issues',
          value: overview.issueMetrics.openIssues.toString(),
          subtitle: 'This month: ${overview.issueMetrics.issuesThisMonth}',
          icon: Icons.error_outline,
          color: Colors.red,
        ),
        DashboardCard(
          title: 'Maintenance',
          value: overview.maintenanceMetrics.pendingMaintenance.toString(),
          subtitle: 'This month: ${overview.maintenanceMetrics.maintenanceThisMonth}',
          icon: Icons.build,
          color: Colors.teal,
        ),
        DashboardCard(
          title: 'Warranty Expiry',
          value: overview.assetMetrics.assetsNearWarrantyExpiry.toString(),
          subtitle: 'Assets near expiry',
          icon: Icons.warning,
          color: Colors.amber,
        ),
      ],
    );
  }
}

class EmployeeDashboardCards extends StatelessWidget {
  final DashboardOverview overview;

  const EmployeeDashboardCards({Key? key, required this.overview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DashboardCard(
          title: 'My Assets',
          value: '0', // This would come from user-specific data
          subtitle: 'Assigned to me',
          icon: Icons.laptop,
          color: Colors.blue,
        ),
        DashboardCard(
          title: 'My Licenses',
          value: '0', // This would come from user-specific data
          subtitle: 'Active licenses',
          icon: Icons.verified_user,
          color: Colors.green,
        ),
        DashboardCard(
          title: 'My Issues',
          value: '0', // This would come from user-specific data
          subtitle: 'Open issues',
          icon: Icons.error_outline,
          color: Colors.red,
        ),
        DashboardCard(
          title: 'Notifications',
          value: '0', // This would come from user-specific data
          subtitle: 'Unread alerts',
          icon: Icons.notifications,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class QuickActionsWidget extends StatelessWidget {
  final UserRole userRole;
  final VoidCallback? onAddAsset;
  final VoidCallback? onAddUser;
  final VoidCallback? onAddLicense;
  final VoidCallback? onReportIssue;
  final VoidCallback? onAssignAsset;

  const QuickActionsWidget({
    Key? key,
    required this.userRole,
    this.onAddAsset,
    this.onAddUser,
    this.onAddLicense,
    this.onReportIssue,
    this.onAssignAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (userRole == UserRole.ADMIN) {
      actions = [
        _buildActionButton(
          'Add User',
          Icons.person_add,
          Colors.blue,
          onAddUser,
        ),
        _buildActionButton(
          'Add Asset',
          Icons.add_box,
          Colors.green,
          onAddAsset,
        ),
        _buildActionButton(
          'Add License',
          Icons.add_circle,
          Colors.orange,
          onAddLicense,
        ),
        _buildActionButton(
          'Report Issue',
          Icons.report,
          Colors.red,
          onReportIssue,
        ),
      ];
    } else if (userRole == UserRole.ASSET_MANAGER) {
      actions = [
        _buildActionButton(
          'Add Asset',
          Icons.add_box,
          Colors.green,
          onAddAsset,
        ),
        _buildActionButton(
          'Assign Asset',
          Icons.assignment,
          Colors.blue,
          onAssignAsset,
        ),
        _buildActionButton(
          'Report Issue',
          Icons.report,
          Colors.red,
          onReportIssue,
        ),
      ];
    } else if (userRole == UserRole.EMPLOYEE) {
      actions = [
        _buildActionButton(
          'Report Issue',
          Icons.report,
          Colors.red,
          onReportIssue,
        ),
      ];
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String title,
      IconData icon,
      Color color,
      VoidCallback? onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Shimmer effect for loading states
class DashboardShimmerCard extends StatefulWidget {
  const DashboardShimmerCard({Key? key}) : super(key: key);

  @override
  State<DashboardShimmerCard> createState() => _DashboardShimmerCardState();
}

class _DashboardShimmerCardState extends State<DashboardShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300]!.withOpacity(0.5 + _animation.value * 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: double.infinity,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey[300]!.withOpacity(0.5 + _animation.value * 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: 100,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey[300]!.withOpacity(0.5 + _animation.value * 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!.withOpacity(0.5 + _animation.value * 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// Dashboard Statistics Card
class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const DashboardStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


// Asset Distribution Chart
class AssetDistributionChart extends StatelessWidget {
  final Map<String, int> distribution;

  const AssetDistributionChart({
    Key? key,
    required this.distribution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.pink,
    ];

    List<PieChartSectionData> sections = [];
    int colorIndex = 0;

    distribution.forEach((category, count) {
      final total = distribution.values.reduce((a, b) => a + b);
      final percentage = (count / total * 100);

      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: count.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              startDegreeOffset: -90,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: distribution.entries.map((entry) {
              final index = distribution.keys.toList().indexOf(entry.key);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${entry.key} (${entry.value})',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}


// Alert Item Widget
class AlertItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const AlertItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Activity Item Widget
class ActivityItem extends StatelessWidget {
  final String action;
  final String itemName;
  final String userName;
  final DateTime timestamp;
  final String type;

  const ActivityItem({
    Key? key,
    required this.action,
    required this.itemName,
    required this.userName,
    required this.timestamp,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData getIconForAction() {
      switch (action.toLowerCase()) {
        case 'assigned':
          return Icons.person_add;
        case 'returned':
          return Icons.person_remove;
        case 'created':
          return Icons.add_circle_outline;
        case 'updated':
          return Icons.edit;
        case 'deleted':
          return Icons.delete_outline;
        default:
          return Icons.info_outline;
      }
    }

    Color getColorForAction() {
      switch (action.toLowerCase()) {
        case 'assigned':
          return Colors.green;
        case 'returned':
          return Colors.orange;
        case 'created':
          return Colors.blue;
        case 'updated':
          return Colors.purple;
        case 'deleted':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: getColorForAction().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              getIconForAction(),
              color: getColorForAction(),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' $action '),
                      TextSpan(
                        text: itemName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${type.toUpperCase()} • ${DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Action Button Widget
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const QuickActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}