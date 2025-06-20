import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'package:ams/services/web_service.dart';
import 'package:ams/utils/constants.dart';

class UserRepository {
  final WebService webService;

  UserRepository({required this.webService});

  Future<List<User>> fetchUsers() async {
    try {
      final String responseString = await webService.fetchData(ApiEndpoints.getUsers);
      final dynamic response = jsonDecode(responseString); // Changed to dynamic

      if (kDebugMode) {
        print('[UserRepository] Fetch users response: $response');
      }

      // Handle different response structures
      List<dynamic> usersJson;

      if (response is Map<String, dynamic>) {
        // Response is a Map - check for different structures
        if (response['success'] == true && response['data'] != null) {
          usersJson = response['data'] as List<dynamic>;
        } else if (response['users'] != null) {
          usersJson = response['users'] as List<dynamic>;
        } else {
          throw Exception('Invalid response format: Map without expected data structure');
        }
      } else if (response is List) {
        // Response is directly a List
        usersJson = response;
      } else {
        throw Exception('Invalid response format: Expected Map or List');
      }

      return usersJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching users: $e");
      }
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<void> addUser(User newUser) async {
    try {
      final Map<String, dynamic> userData = newUser.toJson();

      if (kDebugMode) {
        print('[UserRepository] Adding user with data: $userData');
      }

      final responseString = await webService.postData(ApiEndpoints.createUser, userData);
      final Map<String, dynamic> response = jsonDecode(responseString);

      if (kDebugMode) {
        print('[UserRepository] Add user response: $response');
      }

      // Check for success in different response formats
      if (response['success'] == false) {
        throw Exception(response['message'] ?? response['description'] ?? 'Failed to add user');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding user: $e");
      }
      throw Exception('Failed to add user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      if (user.id == null) {
        throw Exception('User ID is required for update');
      }

      final Map<String, dynamic> userData = user.toJson();
      // Remove password from update payload if it's null or empty
      if (userData['password'] == null || userData['password'].toString().isEmpty) {
        userData.remove('password');
      }

      final responseString = await webService.putData('${ApiEndpoints.getUsers}/${user.id}', userData);

      if (kDebugMode) {
        print("Update User API Response: $responseString");
      }

      final Map<String, dynamic> response = jsonDecode(responseString);
      if (response['success'] == false) {
        throw Exception(response['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating user: $e");
      }
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      final responseString = await webService.deleteData('${ApiEndpoints.getUsers}/$userId');

      if (kDebugMode) {
        print("Delete User API Response: $responseString");
      }

      final Map<String, dynamic> response = jsonDecode(responseString);
      if (response['success'] == false) {
        throw Exception(response['message'] ?? 'Failed to delete user');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting user: $e");
      }
      throw Exception('Failed to delete user: $e');
    }
  }
}