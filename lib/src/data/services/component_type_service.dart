import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/component_type_models.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class ComponentTypeService {
  final String baseUrl = 'http://172.22.175.245:8080/component-types';
  late http.Client httpClient;

  ComponentTypeService(AuthProvider authProvider) {
    httpClient = AuthenticatedHttpClient(http.Client(), authProvider);
  }

  Future<List<ComponentType>> fetchComponentTypes() async {
    final response = await httpClient.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((componentType) => ComponentType.fromJson(componentType as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load component types: ${response.reasonPhrase}');
    }
  }

  Future<ComponentType> fetchComponentType(int id) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ComponentType.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load component type: ${response.reasonPhrase}');
    }
  }

  Future<ComponentType> createComponentType(CreateComponentTypeDto createComponentTypeDto) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(createComponentTypeDto.toJson()),
    );

    if (response.statusCode == 201) {
      return ComponentType.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create component type: ${response.reasonPhrase}');
    }
  }

  Future<ComponentType> updateComponentType(int id, UpdateComponentTypeDto updateComponentTypeDto) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateComponentTypeDto.toJson()),
    );

    if (response.statusCode == 200) {
      return ComponentType.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update component type: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteComponentType(int id) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete component type: ${response.reasonPhrase}');
    }
  }
}