// role_based_dashboard_screen.dart
import 'package:ams/dashboard/screens/widgets/dashboard_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ams/user_login/models/login.dart';
import 'package:ams/services/common_model.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'package:ams/dashboard/screens/widgets/admin_dashboard_widget.dart';
import 'package:ams/dashboard/screens/widgets/asset_manager_dashboard_widget.dart';
import 'package:ams/dashboard/screens/widgets/employee_dashboard_widget.dart';
import 'package:ams/dashboard/screens/widgets/dashboard_loading_widget.dart';

class RoleBasedDashboardScreen extends StatefulWidget {
  final User user;

  const RoleBasedDashboardScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<RoleBasedDashboardScreen> createState() => _RoleBasedDashboardScreenState();
}

class _RoleBasedDashboardScreenState extends State<RoleBasedDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    context.read<DashboardBloc>().add(LoadDashboardOverview());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getDashboardTitle()),
        backgroundColor: _getRoleColor(),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardBloc>().add(RefreshDashboard());
            },
          ),
          _buildProfileMenu(),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const DashboardLoadingWidget();
          }

          if (state is DashboardError) {
            return DashboardErrorWidget(
              message: state.message,
              onRetry: _loadDashboardData,
            );
          }

          if (state is DashboardRefreshing) {
            return Stack(
              children: [
                _buildDashboardContent(state.overview),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(),
                ),
              ],
            );
          }

          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(RefreshDashboard());
              },
              child: _buildDashboardContent(state.overview),
            );
          }

          return const DashboardLoadingWidget();
        },
      ),
    );
  }

  Widget _buildDashboardContent(overview) {
    switch (widget.user.role) {
      case UserRole.ADMIN:
        return AdminDashboardWidget(
          user: widget.user,
          overview: overview,
        );
      case UserRole.ASSET_MANAGER:
        return AssetManagerDashboardWidget(
          user: widget.user,
          overview: overview,
        );
      case UserRole.EMPLOYEE:
        return EmployeeDashboardWidget(
          user: widget.user,
          overview: overview,
        );
      default:
        return DashboardErrorWidget(
          message: 'Invalid user role: ${widget.user.role.displayName}',
          onRetry: () {
            // Handle role mismatch - logout user
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
                  (route) => false,
            );
          },
        );
    }
  }

  String _getDashboardTitle() {
    switch (widget.user.role) {
      case UserRole.ADMIN:
        return 'Admin Dashboard';
      case UserRole.ASSET_MANAGER:
        return 'Asset Manager Dashboard';
      case UserRole.EMPLOYEE:
        return 'My Dashboard';
      default:
        return 'Dashboard';
    }
  }

  Color _getRoleColor() {
    switch (widget.user.role) {
      case UserRole.ADMIN:
        return Colors.deepOrange;
      case UserRole.ASSET_MANAGER:
        return Colors.blue;
      case UserRole.EMPLOYEE:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          _handleLogout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundColor: _getRoleColor(),
              child: Text(
                widget.user.firstName.isNotEmpty ? widget.user.firstName[0] : 'U',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(widget.user.fullName),
            subtitle: Text(widget.user.role.displayName),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            dense: true,
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
      ],
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                    (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
