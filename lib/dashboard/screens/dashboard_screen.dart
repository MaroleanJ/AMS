import 'package:flutter/material.dart';
import 'package:ams/user_login/models/login.dart';
import 'role_based_dashboard_screen.dart';

class DashboardScreen extends StatelessWidget {
  final User user;

  const DashboardScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoleBasedDashboardScreen(user: user);
  }
}