import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticatedHttpClient extends http.BaseClient {
  final http.Client _inner;
  Completer<String>? _tokenCompleter;
  String? _cachedToken;

  AuthenticatedHttpClient(this._inner);

  Future<String> _loadAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  Future<String> _refreshToken() async {
    if (_tokenCompleter != null && !_tokenCompleter!.isCompleted) {
      // Jeśli token już jest odświeżany, czekaj na jego odświeżenie
      return _tokenCompleter!.future;
    }

    _tokenCompleter = Completer<String>();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String refreshToken = prefs.getString('refresh_token')!;
    var response = await _inner.post(
      Uri.parse('http://172.22.175.245:8080/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      prefs.setString('access_token', data['access_token']);
      prefs.setString('refresh_token', data['refresh_token']);
      _cachedToken = data['access_token'];
      _tokenCompleter!.complete(_cachedToken);
    } else {
      _tokenCompleter!.completeError('Failed to refresh token');
      throw Exception('Failed to refresh token');
    }

    return _tokenCompleter!.future;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var token = _cachedToken ?? await _loadAuthToken();
    request.headers['Authorization'] = 'Bearer $token';
    var response = await _inner.send(request);

    if (response.statusCode == 401) {
      token = await _refreshToken();
      http.BaseRequest clonedRequest = _cloneRequest(request);
      clonedRequest.headers['Authorization'] = 'Bearer $token';
      response = await _inner.send(clonedRequest);
    }

    return response;
  }

  http.BaseRequest _cloneRequest(http.BaseRequest request) {
    if (request is http.MultipartRequest) {
      var newRequest = http.MultipartRequest(request.method, request.url)
        ..headers.addAll(request.headers)
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
      return newRequest;
    } else if (request is http.Request) {
      var newRequest = http.Request(request.method, request.url)
        ..headers.addAll(request.headers)
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection
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

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthenticatedHttpClient extends http.BaseClient {
//   final http.Client _inner;

//   AuthenticatedHttpClient(this._inner);

//   Future<String?> _loadAuthToken() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('access_token');
//   }

//   Future<String> _refreshToken() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String refreshToken = prefs.getString('refresh_token')!;
//     var response = await _inner.post(
//       Uri.parse('http://172.22.175.245:8080/auth/refresh'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'refresh_token': refreshToken}),
//     );
//     if (response.statusCode == 201) {
//       var data = json.decode(response.body);
//       prefs.setString('access_token', data['access_token']);
//       prefs.setString('refresh_token', data['refresh_token']);
//       return data['access_token'];
//     } else {
//       throw Exception('Failed to refresh token');
//     }
//   }

//   // @override
//   // Future<http.StreamedResponse> send(http.BaseRequest request) async {
//   //   var token = await _loadAuthToken();
//   //   request.headers['Authorization'] = 'Bearer $token';
//   //   var response = await _inner.send(request);
//   //   if (response.statusCode == 401) {
//   //     token = await _refreshToken();
//   //     request.headers['Authorization'] = 'Bearer $token';
//   //     response = await _inner.send(request);  // Wysłanie zapytania jeszcze raz z odświeżonym tokenem
//   //   }
//   //   return response;
//   // }
//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) async {
//     var token = await _loadAuthToken();
//     request.headers['Authorization'] = 'Bearer $token';
//     var response = await _inner.send(request);
//     if (response.statusCode == 401) {
//       token = await _refreshToken();

//       // Klonowanie żądania
//       http.BaseRequest clonedRequest = _cloneRequest(request);
//       clonedRequest.headers['Authorization'] = 'Bearer $token';

//       // Ponowne wysłanie zaktualizowanego żądania
//       response = await _inner.send(clonedRequest);
//     }
//     return response;
//   }

//   http.BaseRequest _cloneRequest(http.BaseRequest request) {
//     // Tworzenie nowego żądania na podstawie oryginalnego
//     if (request is http.MultipartRequest) {
//       var newRequest = http.MultipartRequest(request.method, request.url)
//         ..headers.addAll(request.headers)
//         ..followRedirects = request.followRedirects
//         ..maxRedirects = request.maxRedirects
//         ..persistentConnection = request.persistentConnection;

//       // Dodawanie pól i plików specyficznych dla MultipartRequest
//       newRequest.fields.addAll(request.fields);
//       newRequest.files.addAll(request.files);

//       return newRequest;
//     } else if (request is http.Request) {
//       var newRequest = http.Request(request.method, request.url)
//         ..headers.addAll(request.headers)
//         ..followRedirects = request.followRedirects
//         ..maxRedirects = request.maxRedirects
//         ..persistentConnection = request.persistentConnection
//         ..body = request.body
//         ..encoding = request.encoding;

//       return newRequest;
//     } else if (request is http.StreamedRequest) {
//       throw UnsupportedError('Cloning streamed requests is not supported');
//     } else {
//       throw Exception('Request type is not supported for cloning');
//     }
//   }
// }
