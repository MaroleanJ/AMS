import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../services/mock_data_service.dart';
import '../../services/web_service.dart';
import '../models/dashboard_summary.dart';
import 'package:ams/utils/constants.dart';

class DashboardRepository {
  final WebService webService;
  final MockDataService mockDataService;
  final bool useMockData;

  DashboardRepository({
    required this.webService,
    required this.mockDataService,
    this.useMockData = true,
  });

  Future<DashboardSummary> fetchDashboardSummary() async {
    try {
      if (useMockData) {
        await Future.delayed(const Duration(milliseconds: 500)); // simulate latency
        final mockResponse = mockDataService.generateMockDashboardData();

        if (kDebugMode) {
          print("Mock Dashboard Data: ${jsonEncode(mockResponse)}");
        }

        return DashboardSummary.fromJson(mockResponse['data']);
      } else {
        final String responseString =
        await webService.fetchData(ApiEndpoints.dashboardSummary);
        final Map<String, dynamic> response = jsonDecode(responseString);

        if (response['success'] != true) {
          throw Exception(response['message'] ?? 'Failed to fetch dashboard summary');
        }

        return DashboardSummary.fromJson(response['data']);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching dashboard summary: $e");
      }
      throw Exception('Failed to fetch dashboard summary: $e');
    }
  }
}