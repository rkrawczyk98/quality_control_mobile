import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/component_status_models.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class ComponentStatusService {
  final String baseUrl = 'http://172.22.175.245:8080/component-statuses';
  late http.Client httpClient;

  ComponentStatusService(AuthProvider authProvider) {
    httpClient = AuthenticatedHttpClient(http.Client(), authProvider);
  }

  Future<List<ComponentStatus>> fetchComponentStatuses() async {
    final response = await httpClient.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((item) => ComponentStatus.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load Component statuses');
    }
  }

  Future<ComponentStatus> fetchComponentStatus(int id) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return ComponentStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Component status');
    }
  }

  Future<ComponentStatus> createComponentStatus(
      CreateComponentStatusDto dto) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 201) {
      return ComponentStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create Component status');
    }
  }

  Future<void> deleteComponentStatus(int id) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete Component status');
    }
  }

  Future<ComponentStatus> updateComponentStatus(
      int id, UpdateComponentStatusDto dto) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return ComponentStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update Component status');
    }
  }
}
