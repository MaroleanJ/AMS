import 'package:ams/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard/screens/dashboard_screen.dart';

void main() {
  // Initialize service locator
  ServiceLocator.instance.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Management Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => ServiceLocator.instance.createDashboardBloc(),
        child: DashboardScreen(),
      ),
    );
  }
}