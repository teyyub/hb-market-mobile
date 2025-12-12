import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // final String baseUrl;
  static const String baseUrl = 'http://161.97.105.143:8044';
  // ApiClient({required this.baseUrl});

  /// Helper: get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    // print('token...${token}');
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.get(url, headers: headers);
    return response;
  }

  Future<http.Response> getWithQuery(
    String endpoint, {
    Map<String, String>? queryParams, // optional query parameters
  }) async {
    final token = await _getToken();

    debugPrint('getWithQuery...${queryParams}');
    final uri = queryParams != null
        ? Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams)
        : Uri.parse('$baseUrl$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(uri, headers: headers);
    return response;
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    return response;
  }

  // PUT request
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.put(
      url,
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
    return response;
  }

  // DELETE request
  Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.delete(
      url,
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
    return response;
  }
}
