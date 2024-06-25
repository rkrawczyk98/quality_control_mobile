class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int? userId;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.userId,
  });

  factory AuthTokens.fromMap(Map<String, dynamic> map) {
    return AuthTokens(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
      userId: map['user_id'] as int?,
    );
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest(this.refreshToken);

  Map<String, dynamic> toJson() {
    return {'refresh_token': refreshToken};
  }
}

class LogoutSingleDeviceRequest {
  final String refreshToken;

  LogoutSingleDeviceRequest(this.refreshToken);

  Map<String, dynamic> toJson() {
    return {'refresh_token': refreshToken};
  }
}

class LogoutAllDevicesRequest {
  final int userId;

  LogoutAllDevicesRequest(this.userId);

  Map<String, dynamic> toJson() {
    return {'user_id': userId};
  }
}
