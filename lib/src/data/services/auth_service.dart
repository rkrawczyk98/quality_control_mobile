import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://172.22.175.245:8080/auth';
  final http.Client httpClient;

  AuthService() : httpClient = http.Client();

  Future<Map<String, dynamic>> login(Map<String, dynamic> loginData) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<void> logoutAll(int userId) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to logout');
    }
  }

  Future<void> logoutSingle(String refreshToken) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/logout-single'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to logout from single device');
    }
  }
}
