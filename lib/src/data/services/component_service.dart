import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/models/component_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class ComponentService {
  final String baseUrl = 'http://172.22.175.245:8080/components';
  http.Client httpClient = AuthenticatedHttpClient(http.Client());
  String? _jwtToken;

  Future<void> _loadAuthToken() async {
    if (_jwtToken == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _jwtToken = prefs.getString('access_token');
    }
  }

  Future<List<Component>> fetchComponents() async {
    await _loadAuthToken();
    final response = await httpClient.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((item) => Component.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load components');
    }
  }

  Future<List<Component>> fetchComponentsByDelivery(int id) async {
    await _loadAuthToken();
    final response = await httpClient.get(
      Uri.parse('$baseUrl/byDeliveryId/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((item) => Component.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load components');
    }
  }

  Future<Component> fetchComponent(int id) async {
    await _loadAuthToken();
    final response = await httpClient.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      return Component.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load component');
    }
  }

  Future<Component> createComponent(
      CreateComponentDto createComponentDto) async {
    await _loadAuthToken();
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(createComponentDto.toJson()),
    );

    if (response.statusCode == 201) {
      return Component.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create component');
    }
  }

  Future<void> deleteComponent(int id) async {
    await _loadAuthToken();
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete component');
    }
  }
}
