// dashboard_repository.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ams/dashboard/models/dashboard_models.dart';
import 'package:ams/services/web_service.dart';
import 'package:ams/utils/constants.dart';

class DashboardRepository {
  final WebService webService;

  DashboardRepository({required this.webService});

  Future<DashboardOverview> getDashboardOverview() async {
    try {
      if (kDebugMode) {
        print('[DashboardRepository] Fetching dashboard overview');
      }

      final String responseString = await webService.fetchData(
        'api/v1/dashboard/overview',
      );

      if (kDebugMode) {
        print('[DashboardRepository] Dashboard overview response: $responseString');
      }

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to load dashboard data');
      }

      final Map<String, dynamic> data = response['data'];
      return DashboardOverview.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardRepository] Dashboard overview error: $e');
      }

      if (e.toString().contains('NetworkException')) {
        throw Exception('Network error. Please check your connection.');
      } else if (e.toString().contains('HttpException')) {
        throw Exception('Server error. Please try again later.');
      }

      throw Exception('Failed to load dashboard: ${e.toString()}');
    }
  }

  Future<AssetMetrics> getAssetMetrics() async {
    try {
      if (kDebugMode) {
        print('[DashboardRepository] Fetching asset metrics');
      }

      final String responseString = await webService.fetchData(
        'api/v1/dashboard/assets/metrics',
      );

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to load asset metrics');
      }

      final Map<String, dynamic> data = response['data'];
      return AssetMetrics.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardRepository] Asset metrics error: $e');
      }
      throw Exception('Failed to load asset metrics: ${e.toString()}');
    }
  }

  Future<MaintenanceMetrics> getMaintenanceMetrics() async {
    try {
      if (kDebugMode) {
        print('[DashboardRepository] Fetching maintenance metrics');
      }

      final String responseString = await webService.fetchData(
        'api/v1/dashboard/maintenance/metrics',
      );

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to load maintenance metrics');
      }

      final Map<String, dynamic> data = response['data'];
      return MaintenanceMetrics.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardRepository] Maintenance metrics error: $e');
      }
      throw Exception('Failed to load maintenance metrics: ${e.toString()}');
    }
  }

  Future<SoftwareLicenseMetrics> getLicenseMetrics() async {
    try {
      if (kDebugMode) {
        print('[DashboardRepository] Fetching license metrics');
      }

      final String responseString = await webService.fetchData(
        'api/v1/dashboard/licenses/metrics',
      );

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to load license metrics');
      }

      final Map<String, dynamic> data = response['data'];
      return SoftwareLicenseMetrics.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardRepository] License metrics error: $e');
      }
      throw Exception('Failed to load license metrics: ${e.toString()}');
    }
  }

  Future<SubscriptionMetrics> getSubscriptionMetrics() async {
    try {
      if (kDebugMode) {
        print('[DashboardRepository] Fetching subscription metrics');
      }

      final String responseString = await webService.fetchData(
        'api/v1/dashboard/subscriptions/metrics',
      );

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to load subscription metrics');
      }

      final Map<String, dynamic> data = response['data'];
      return SubscriptionMetrics.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardRepository] Subscription metrics error: $e');
      }
      throw Exception('Failed to load subscription metrics: ${e.toString()}');
    }
  }

  Future<IssueMetrics> getIssueMetrics() async {
    try {
      if (kDebugMode) {
        print('[DashboardRepository] Fetching issue metrics');
      }

      final String responseString = await webService.fetchData(
        'api/v1/dashboard/issues/metrics',
      );

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to load issue metrics');
      }

      final Map<String, dynamic> data = response['data'];
      return IssueMetrics.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardRepository] Issue metrics error: $e');
      }
      throw Exception('Failed to load issue metrics: ${e.toString()}');
    }
  }

  Future<UpcomingEvents> getUpcomingEvents() async {
    try {
      if (kDebugMode) {
        print('[DashboardRepository] Fetching upcoming events');
      }

      final String responseString = await webService.fetchData(
        'api/v1/dashboard/events/upcoming',
      );

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to load upcoming events');
      }

      final Map<String, dynamic> data = response['data'];
      return UpcomingEvents.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardRepository] Upcoming events error: $e');
      }
      throw Exception('Failed to load upcoming events: ${e.toString()}');
    }
  }

  Future<FinancialSummary> getFinancialSummary() async {
    try {
      if (kDebugMode) {
        print('[DashboardRepository] Fetching financial summary');
      }

      final String responseString = await webService.fetchData(
        'api/v1/dashboard/financial/summary',
      );

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to load financial summary');
      }

      final Map<String, dynamic> data = response['data'];
      return FinancialSummary.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        print('[DashboardRepository] Financial summary error: $e');
      }
      throw Exception('Failed to load financial summary: ${e.toString()}');
    }
  }
}