import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/models/auth_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  AuthTokens? _tokens;

  AuthTokens? get tokens => _tokens;

  Future<void> setTokens(AuthTokens tokens) async {
    _tokens = tokens;
    await _saveTokensAndUserId(tokens);
  }

  Future<void> _saveTokensAndUserId(AuthTokens tokens) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', tokens.accessToken);
    await prefs.setString('refresh_token', tokens.refreshToken);
    if (tokens.userId != null) {
      await prefs.setInt('user_id', tokens.userId!);
    }
    notifyListeners();
  }

  Future<void> clearTokens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_id');
    _tokens = null;
    notifyListeners();
  }

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
