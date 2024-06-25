import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/auth_models.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class AuthService {
  final String baseUrl = 'http://172.22.175.245:8080/auth';
  http.Client httpClient;
  AuthProvider authProvider;

  AuthService(this.authProvider)
      : httpClient = AuthenticatedHttpClient(http.Client(), authProvider);

  void initializeAuthProvider(AuthProvider provider) {
    authProvider = provider;
    httpClient = AuthenticatedHttpClient(http.Client(), provider);
  }

  Future<Map<String, dynamic>> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      await authProvider.setTokens(AuthTokens(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
        userId: data['user_id'],
      ));
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    final refreshToken = authProvider.tokens?.refreshToken;
    if (refreshToken == null) throw Exception('No refresh token available');

    final response = await httpClient.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      await authProvider.setTokens(AuthTokens(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
        userId: authProvider.tokens?.userId,
      ));
      return data;
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<void> logoutAll() async {
    final userId = authProvider.tokens?.userId;
    if (userId == null) throw Exception('No user ID found');

    final response = await httpClient.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await authProvider.clearTokens();
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<void> logoutSingle() async {
    final refreshToken = authProvider.tokens?.refreshToken;
    if (refreshToken == null) throw Exception('No refresh token available');

    final response = await httpClient.post(
      Uri.parse('$baseUrl/logout-single'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await authProvider.clearTokens();
    } else {
      throw Exception('Failed to logout from single device');
    }
  }
}
