import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/data/services/auth_service.dart';
import 'package:quality_control_mobile/src/models/auth_models.dart';

class AuthController {
  final AuthService _service;
  final AuthProvider _authProvider;

  AuthController(this._authProvider)
      : _service = AuthService(_authProvider);

  Future<void> login(String username, String password) async {
    final loginRequest = LoginRequest(username: username, password: password);
    final response = await _service.login(loginRequest);
    final tokens = AuthTokens(
      accessToken: response['access_token'],
      refreshToken: response['refresh_token'],
      userId: response['user_id'] as int?,
    );
    await _authProvider.setTokens(tokens);
  }

  Future<void> refreshToken() async {
    final String? refreshToken = _authProvider.tokens?.refreshToken;
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }
    final response = await _service.refreshToken();
    final tokens = AuthTokens(
      accessToken: response['access_token'],
      refreshToken: response['refresh_token'],
      userId: null,
    );
    await _authProvider.setTokens(tokens);
  }

  Future<void> logoutAllDevices() async {
    final int? userId = _authProvider.tokens?.userId;
    if (userId == null) {
      throw Exception('No user ID found');
    }
    await _service.logoutAll();
    await _authProvider.clearTokens();
  }

  Future<void> logoutSingleDevice() async {
    final String? refreshToken = _authProvider.tokens?.refreshToken;
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }
    await _service.logoutSingle();
    await _authProvider.clearTokens();
  }
}
