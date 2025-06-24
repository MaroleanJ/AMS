import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/login.dart';
import '../models/login_request.dart';
import '../../services/web_service.dart';
import 'package:ams/utils/constants.dart';

class AuthRepository {
  final WebService webService;

  AuthRepository({required this.webService});

  Future<User> login(LoginRequest loginRequest) async {
    try {
      if (kDebugMode) {
        print('[AuthRepository] Attempting login for: ${loginRequest.email}');
      }

      final String responseString = await webService.postData(
        ApiEndpoints.login,
        loginRequest.toJson(),
      );

      if (kDebugMode) {
        print('[AuthRepository] Login response: $responseString');
      }

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Login failed');
      }

      final Map<String, dynamic> userData = response['data'];
      return User.fromJson(userData);
    } catch (e) {
      if (kDebugMode) {
        print('[AuthRepository] Login error: $e');
      }

      // Handle specific error messages
      if (e.toString().contains('Invalid email or password')) {
        throw Exception('Invalid email or password');
      } else if (e.toString().contains('NetworkException')) {
        throw Exception('Network error. Please check your connection.');
      } else if (e.toString().contains('HttpException')) {
        throw Exception('Server error. Please try again later.');
      }

      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      // Clear any stored user data here if needed
      if (kDebugMode) {
        print('[AuthRepository] User logged out');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[AuthRepository] Logout error: $e');
      }
    }
  }
}