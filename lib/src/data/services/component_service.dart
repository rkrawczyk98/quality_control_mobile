import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart'; // Zaimportuj AuthProvider
import 'package:quality_control_mobile/src/models/component_models.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class ComponentService {
  final String baseUrl = 'http://172.22.175.245:8080/components';
  late http.Client httpClient;

  ComponentService(AuthProvider authProvider) {
    httpClient = AuthenticatedHttpClient(http.Client(), authProvider);
  }

  Future<List<Component>> fetchComponents() async {
    final response = await httpClient.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
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
    final response = await httpClient.get(
      Uri.parse('$baseUrl/byDeliveryId/$id'),
      headers: {'Content-Type': 'application/json'},
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
    final response = await httpClient.get(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Component.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load component');
    }
  }

  Future<Component> createComponent(
      CreateComponentDto createComponentDto) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(createComponentDto.toJson()),
    );

    if (response.statusCode == 201) {
      return Component.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create component');
    }
  }

  Future<void> deleteComponent(int id) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete component');
    }
  }

  Future<Component> updateComponent(int id, UpdateComponentDto dto) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      return Component.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update component');
    }
  }
}
