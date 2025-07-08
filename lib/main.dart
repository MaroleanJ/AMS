import 'package:ams/services/common_model.dart';
import 'package:ams/services/service_locator.dart';
import 'package:ams/services/web_service.dart';
import 'package:ams/user_login/bloc/auth_bloc.dart';
import 'package:ams/user_login/bloc/auth_event.dart';
import 'package:ams/user_login/bloc/auth_state.dart';
import 'package:ams/user_login/models/login.dart';
import 'package:ams/user_login/repositories/auth_repository.dart';
import 'package:ams/user_login/screens/login_screen.dart';
import 'package:ams/users_management/screens/users_screen.dart';
import 'package:ams/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ams/users_management/bloc/user_event.dart';

import 'dashboard/bloc/dashboard_provider.dart';
import 'dashboard/screens/role_based_dashboard_screen.dart';

void main() {
  // Initialize service locator
  ServiceLocator.instance.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Bloc - Available throughout the app
        BlocProvider<AuthBloc>(
          create: (context) => ServiceLocator.instance.createAuthBloc()
            ..add(CheckAuthStatus()), // Check if user is already logged in
        ),
        // User Bloc - Only created when needed
        BlocProvider(
          create: (context) => ServiceLocator.instance.createUserBloc(),
        ),
        // Add other global BlocProviders here if needed
      ],
      child: MaterialApp(
      title: 'AMS Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: AuthRepository(
                webService: WebService(baseUrl: ApiEndpoints.baseUrl),
              ),
            )..add(CheckAuthStatus()),
          ),
        ],
        child: AppNavigator(
          webService: WebService(baseUrl: ApiEndpoints.baseUrl),
        ),
      ),
      ),
    );
  }
}


class AppNavigator extends StatelessWidget {
  final WebService webService;

  const AppNavigator({Key? key, required this.webService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return DashboardProvider(
            user: state.user,
            webService: webService,
          );
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen(); // Your existing login screen
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Authentication Error',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to login
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}