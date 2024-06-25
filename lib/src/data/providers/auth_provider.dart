import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quality_control_mobile/src/models/auth_models.dart';
import 'package:quality_control_mobile/src/data/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  AuthTokens? _tokens;
  final AuthService _authService;

  AuthProvider(this._authService);

  AuthTokens? get tokens => _tokens;

  Future<void> setTokens(AuthTokens tokens) async {
    _tokens = tokens;
    await _saveTokens();
    notifyListeners();
  }

  Future<void> _saveTokens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', _tokens?.accessToken ?? '');
    await prefs.setString('refresh_token', _tokens?.refreshToken ?? '');
    if (_tokens?.userId != null) {
      await prefs.setInt('user_id', _tokens!.userId!);
    }
  }

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String> refreshToken() async {
    final refreshToken = _tokens?.refreshToken;
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }
    final newTokens = await _authService.refreshToken(refreshToken);
    await setTokens(AuthTokens.fromMap(newTokens));
    return _tokens!.accessToken;
  }

  Future<void> clearTokens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_id');
    _tokens = null;
    notifyListeners();
  }
}
