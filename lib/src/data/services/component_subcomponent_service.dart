import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/component_subcomponent_models.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class ComponentSubcomponentService {
  final String baseUrl = 'http://172.22.175.245:8080/component-subcomponents';
  late http.Client httpClient;

  ComponentSubcomponentService(AuthProvider authProvider) {
    httpClient = AuthenticatedHttpClient(http.Client(), authProvider);
  }

  Future<List<ComponentSubcomponent>> fetchComponentSubcomponents() async {
    final response = await httpClient.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((item) => ComponentSubcomponent.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load component-subcomponents');
    }
  }

  Future<ComponentSubcomponent> fetchComponentSubcomponent(int id) async {
    final response = await httpClient.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return ComponentSubcomponent.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load component-subcomponent');
    }
  }

  Future<ComponentSubcomponent> createComponentSubcomponent(CreateComponentSubcomponentDto dto) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 201) {
      return ComponentSubcomponent.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create component-subcomponent');
    }
  }

  Future<void> deleteComponentSubcomponent(int id) async {
    final response = await httpClient.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete component-subcomponent');
    }
  }

  Future<ComponentSubcomponent> updateComponentSubcomponent(int id, UpdateComponentSubcomponentDto dto) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return ComponentSubcomponent.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update component-subcomponent');
    }
  }
}
