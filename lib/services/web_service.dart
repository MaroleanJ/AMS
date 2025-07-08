import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class WebService {
  final String baseUrl;
  final Duration timeout;

  WebService({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 90),
  });

  /// Fetches data from the given endpoint
  Future<String> fetchData(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      if (kDebugMode) {
        print('[WebService] Making GET request to: $uri');
      }

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(timeout);

      if (kDebugMode) {
        print('[WebService] Response status: ${response.statusCode}');
        print('[WebService] Response body length: ${response.body.length}');
      }

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw HttpException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('[WebService] Error fetching data: $e');
      }

      if (e is HttpException) {
        rethrow;
      } else {
        throw NetworkException('Network error: $e');
      }
    }
  }

  /// Posts data to the given endpoint
  Future<String> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      if (kDebugMode) {
        print('[WebService] Making POST request to: $uri');
      }

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(timeout);

      if (kDebugMode) {
        print('[WebService] Response status: ${response.statusCode}');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      } else {
        throw HttpException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('[WebService] Error posting data: $e');
      }

      if (e is HttpException) {
        rethrow;
      } else {
        throw NetworkException('Network error: $e');
      }
    }
  }

  /// Puts data to the given endpoint
  Future<String> putData(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      if (kDebugMode) {
        print('[WebService] Making PUT request to: $uri');
      }

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      } else {
        throw HttpException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is HttpException) {
        rethrow;
      } else {
        throw NetworkException('Network error: $e');
      }
    }
  }

  /// Deletes data at the given endpoint
  Future<String> deleteData(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      if (kDebugMode) {
        print('[WebService] Making DELETE request to: $uri');
      }

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      } else {
        throw HttpException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is HttpException) {
        rethrow;
      } else {
        throw NetworkException('Network error: $e');
      }
    }
  }
}

/// Custom exception for HTTP errors
class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, this.statusCode);

  @override
  String toString() => 'HttpException: $message (Status: $statusCode)';
}

/// Custom exception for network errors
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}