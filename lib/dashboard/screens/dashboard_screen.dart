import 'package:ams/dashboard/screens/widgets/dashboard_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_summary.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DashboardBloc>().add(RefreshDashboard()),
            tooltip: 'Refresh Dashboard',
          ),
        ],
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () => context.read<DashboardBloc>().add(LoadDashboardSummary()),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoadingState();
          } else if (state is DashboardLoaded) {
            return _buildDashboardContent(state.summary);
          } else if (state is DashboardRefreshing) {
            return Stack(
              children: [
                _buildDashboardContent(state.currentSummary),
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text('Refreshing dashboard...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is DashboardError) {
            return _buildErrorState(state.error);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Loading shimmer widgets
          Row(
            children: [
              Expanded(child: DashboardShimmerCard()),
              SizedBox(width: 16),
              Expanded(child: DashboardShimmerCard()),
              SizedBox(width: 16),
              Expanded(child: DashboardShimmerCard()),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: DashboardShimmerCard()),
              SizedBox(width: 16),
              Expanded(child: DashboardShimmerCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<DashboardBloc>().add(LoadDashboardSummary()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(DashboardSummary summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(),
          const SizedBox(height: 24),

          // Quick Stats Cards
          _buildQuickStatsSection(summary),
          const SizedBox(height: 24),

          // Charts and Alerts Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Charts Section
              Expanded(
                flex: 2,
                child: _buildChartsSection(summary),
              ),
              const SizedBox(width: 16),

              // Alerts and Notifications Section
              Expanded(
                flex: 1,
                child: _buildAlertsSection(summary),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activities and Quick Actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildRecentActivitiesSection(summary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionsSection(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.person, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Admin!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Here\'s your asset management overview for ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection(DashboardSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1200) {
              // Desktop: 4 columns
              return Row(
                children: [
                  Expanded(child: DashboardStatCard(
                    title: 'Total Assets',
                    value: summary.totalAssets.toString(),
                    icon: Icons.devices,
                    color: Colors.blue,
                    subtitle: '${summary.assignedAssets} assigned, ${summary.availableAssets} available',
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: DashboardStatCard(
                    title: 'Software Licenses',
                    value: summary.totalLicenses.toString(),
                    icon: Icons.key,
                    color: Colors.purple,
                    subtitle: '${summary.expiringLicenses} expiring soon',
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: DashboardStatCard(
                    title: 'Open Issues',
                    value: summary.openIssues.toString(),
                    icon: Icons.warning,
                    color: Colors.orange,
                    subtitle: '${summary.resolvedIssues} resolved this month',
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: DashboardStatCard(
                    title: 'Expiring Soon',
                    value: (summary.assetsExpiringSoon + summary.expiringLicenses).toString(),
                    icon: Icons.schedule,
                    color: Colors.red,
                    subtitle: 'Assets & licenses',
                  )),
                ],
              );
            } else {
              // Mobile/Tablet: 2 columns
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: DashboardStatCard(
                        title: 'Total Assets',
                        value: summary.totalAssets.toString(),
                        icon: Icons.devices,
                        color: Colors.blue,
                        subtitle: '${summary.assignedAssets} assigned',
                      )),
                      const SizedBox(width: 16),
                      Expanded(child: DashboardStatCard(
                        title: 'Software Licenses',
                        value: summary.totalLicenses.toString(),
                        icon: Icons.key,
                        color: Colors.purple,
                        subtitle: '${summary.expiringLicenses} expiring',
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: DashboardStatCard(
                        title: 'Open Issues',
                        value: summary.openIssues.toString(),
                        icon: Icons.warning,
                        color: Colors.orange,
                        subtitle: '${summary.resolvedIssues} resolved',
                      )),
                      const SizedBox(width: 16),
                      Expanded(child: DashboardStatCard(
                        title: 'Expiring Soon',
                        value: (summary.assetsExpiringSoon + summary.expiringLicenses).toString(),
                        icon: Icons.schedule,
                        color: Colors.red,
                        subtitle: 'Needs attention',
                      )),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildChartsSection(DashboardSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asset Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (summary.assetDistribution.isNotEmpty)
              SizedBox(
                height: 300,
                child: AssetDistributionChart(
                  distribution: {
                    for (var item in summary.assetDistribution)
                      item.category: item.count // or whatever properties your AssetCategoryDistribution has
                  },
                ),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(Icons.pie_chart_outline, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No data available for chart'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection(DashboardSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.orange[600]),
                const SizedBox(width: 8),
                Text(
                  'Alerts',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (summary.expiringItems.isNotEmpty)
              Column(
                children: summary.expiringItems.take(5).map((item) {
                  return AlertItem(
                    title: item.name,
                    subtitle: '${item.type.toUpperCase()} • Expires in ${item.daysUntilExpiry} days',
                    icon: item.type == 'asset' ? Icons.devices : Icons.key,
                    color: item.daysUntilExpiry <= 7 ? Colors.red : Colors.orange,
                  );
                }).toList(),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
                      SizedBox(height: 16),
                      Text('No alerts at this time'),
                      Text('All systems running smoothly!'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitiesSection(DashboardSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activities',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (summary.recentActivities.isNotEmpty)
              Column(
                children: summary.recentActivities.take(5).map((activity) {
                  return ActivityItem(
                    action: activity.action,
                    itemName: activity.itemName,
                    userName: activity.userName,
                    timestamp: activity.timestamp,
                    type: activity.type,
                  );
                }).toList(),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(Icons.history, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No recent activities'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            QuickActionButton(
              icon: Icons.add_box,
              label: 'Add Asset',
              onPressed: () => _navigateToAddAsset(),
            ),
            const SizedBox(height: 12),
            QuickActionButton(
              icon: Icons.key,
              label: 'Add License',
              onPressed: () => _navigateToAddLicense(),
            ),
            const SizedBox(height: 12),
            QuickActionButton(
              icon: Icons.report_problem,
              label: 'Report Issue',
              onPressed: () => _navigateToReportIssue(),
            ),
            const SizedBox(height: 12),
            QuickActionButton(
              icon: Icons.people,
              label: 'Manage Users',
              onPressed: () => _navigateToManageUsers(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddAsset() {
    // Navigate to add asset screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Add Asset screen')),
    );
  }

  void _navigateToAddLicense() {
    // Navigate to add license screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Add License screen')),
    );
  }

  void _navigateToReportIssue() {
    // Navigate to report issue screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Report Issue screen')),
    );
  }

  void _navigateToManageUsers() {
    // Navigate to manage users screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Manage Users screen')),
    );
  }
}