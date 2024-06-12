import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/data/services/auth_service.dart';
import 'package:quality_control_mobile/src/models/auth_models.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final AuthProvider _authProvider;

  AuthController(this._authProvider);

  Future<void> login(String username, String password) async {
    final loginRequest = LoginRequest(username: username, password: password);
    final response = await _authService.login(loginRequest);
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
    final refreshTokenRequest = RefreshTokenRequest(refreshToken);
    final response = await _authService.refreshToken(refreshTokenRequest);
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
    final logoutRequest = LogoutAllDevicesRequest(userId);
    await _authService.logoutAll(logoutRequest);
    await _authProvider.clearTokens();
  }

  Future<void> logoutSingleDevice() async {
    final String? refreshToken = _authProvider.tokens?.refreshToken;
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }
    final logoutRequest = LogoutSingleDeviceRequest(refreshToken);
    await _authService.logoutSingle(logoutRequest);
    await _authProvider.clearTokens();
  }
}
