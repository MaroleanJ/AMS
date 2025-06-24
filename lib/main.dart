import 'package:ams/services/common_model.dart';
import 'package:ams/services/service_locator.dart';
import 'package:ams/user_login/bloc/auth_bloc.dart';
import 'package:ams/user_login/bloc/auth_event.dart';
import 'package:ams/user_login/bloc/auth_state.dart';
import 'package:ams/user_login/models/login.dart';
import 'package:ams/user_login/screens/login_screen.dart';
import 'package:ams/users_management/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ams/users_management/bloc/user_event.dart';

import 'dashboard/screens/dashboard_screen.dart';

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
        title: 'Asset Management Dashboard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
        // Use AuthWrapper to handle initial route based on auth state
        home: const AuthWrapper(),
        // Define all your routes here
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/users': (context) => const UsersScreen(),
          '/my-assets': (context) => const MyAssetsScreen(),
        },
      ),
    );
  }
}

// AuthWrapper - Determines which screen to show based on authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case AuthInitial:
          // Show loading while checking auth status
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case AuthLoading:
          // Show loading during authentication process
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Authenticating...'),
                  ],
                ),
              ),
            );

          case AuthAuthenticated:
          // User is logged in, show appropriate screen based on role
            final user = (state as AuthAuthenticated).user;
            return RoleBasedHomeScreen(user: user);

          case AuthUnauthenticated:
          // User is not logged in, show login screen
            return const LoginScreen();

          case AuthError:
          // Authentication error, show login with error handling
            return const LoginScreen();

          default:
          // Default case, show login
            return const LoginScreen();
        }
      },
    );
  }
}

// RoleBasedHomeScreen - Shows different home screens based on user role
class RoleBasedHomeScreen extends StatelessWidget {
  final User user;

  const RoleBasedHomeScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // Return appropriate screen based on user role
    switch (user.role) {
      case UserRole.ADMIN:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ServiceLocator.instance.createUserBloc()
                ..add(LoadUsers()),
            ),
            // Add other bloc providers needed for admin
          ],
          child: const DashboardScreen(), // Admin sees dashboard with all features
        );

      case UserRole.ASSET_MANAGER:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ServiceLocator.instance.createUserBloc()
                ..add(LoadUsers()),
            ),
            // Add asset management specific blocs
          ],
          child: const DashboardScreen(), // Asset manager sees dashboard
        );

      case UserRole.EMPLOYEE:
        return MultiBlocProvider(
          providers: [
            // Add employee specific blocs (e.g., MyAssetsBloc)
          ],
          child: const MyAssetsScreen(), // Employee sees only their assets
        );

      default:
        return const MyAssetsScreen(); // Default to employee view
    }
  }
}


class MyAssetsScreen extends StatelessWidget {
  const MyAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'My Assets Screen\n(For Employees)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
