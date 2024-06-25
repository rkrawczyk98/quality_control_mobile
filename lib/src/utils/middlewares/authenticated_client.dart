import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';

class AuthenticatedHttpClient extends http.BaseClient {
  final http.Client _inner;
  final AuthProvider _authProvider;

  AuthenticatedHttpClient(this._inner, this._authProvider);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Ensure the access token is loaded and valid
    var token = await _authProvider.getAccessToken() ?? await _authProvider.refreshToken();

    request.headers['Authorization'] = 'Bearer $token';
    var response = await _inner.send(request);

    // If unauthorized, try refreshing the token
    if (response.statusCode == 401) {
      token = await _authProvider.refreshToken();
      // Clone the request with new token and resend
      request = _cloneRequest(request);
      request.headers['Authorization'] = 'Bearer $token';
      response = await _inner.send(request);
    }

    return response;
  }

  http.BaseRequest _cloneRequest(http.BaseRequest request) {
    if (request is http.Request) {
      var newRequest = http.Request(request.method, request.url)
        ..headers.addAll(request.headers)
        ..body = request.body
        ..encoding = request.encoding;
      return newRequest;
    } else if (request is http.StreamedRequest) {
      throw UnsupportedError('Cloning streamed requests is not supported');
    } else {
      throw Exception('Request type is not supported for cloning');
    }
  }
}
