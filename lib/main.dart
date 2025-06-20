import 'package:ams/services/service_locator.dart';
import 'package:ams/users_management/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ams/users_management/bloc/user_event.dart';

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
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ServiceLocator.instance.createUserBloc()..add(LoadUsers()),
          ),
          // Add other BlocProviders here if needed
        ],
        child: const UsersScreen(),
      ),
    );
  }
}