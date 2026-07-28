import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for API endpoints (Adjust if running on physical device to local IP)
  static String baseUrl = 'http://localhost:4000/api/v1';
  static String? jwtToken;

  static Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (jwtToken != null && jwtToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $jwtToken';
    }
    return headers;
  }

  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      ).timeout(const Duration(seconds: 5));
      return _handleResponse(response);
    } catch (e) {
      // Fallback for Android emulator if localhost fails
      if (baseUrl.contains('localhost')) {
        baseUrl = 'http://10.0.2.2:4000/api/v1';
        return get(endpoint);
      }
      rethrow;
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 5));
      return _handleResponse(response);
    } catch (e) {
      if (baseUrl.contains('localhost')) {
        baseUrl = 'http://10.0.2.2:4000/api/v1';
        return post(endpoint, body);
      }
      rethrow;
    }
  }

  static dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final errorMsg = body is Map && body.containsKey('message')
          ? body['message'].toString()
          : 'HTTP Error ${response.statusCode}';
      throw Exception(errorMsg);
    }
  }
}
