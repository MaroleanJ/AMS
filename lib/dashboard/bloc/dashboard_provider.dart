// dashboard_provider
import 'package:ams/dashboard/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ams/user_login/models/login.dart';
import 'package:ams/services/web_service.dart';
import '../repositories/dashboard_repository.dart';
import '../screens/role_based_dashboard_screen.dart';
import 'dashboard_bloc.dart';

class DashboardProvider extends StatelessWidget {
  final User user;
  final WebService webService;

  const DashboardProvider({
    Key? key,
    required this.user,
    required this.webService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        dashboardRepository: DashboardRepository(webService: webService),
      ),
      child: DashboardScreen(user: user,),
    );
  }
}