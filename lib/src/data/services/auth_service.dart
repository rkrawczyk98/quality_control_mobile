import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/models/auth_models.dart';

class AuthService {
  final String baseUrl = 'http://172.22.175.245:8080/auth';

  Future<Map<String, dynamic>> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> refreshToken(RefreshTokenRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<void> logoutAll(LogoutAllDevicesRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to logout');
    }
  }

    Future<void> logoutSingle(LogoutSingleDeviceRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout-single'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to logout');
    }
  }
}