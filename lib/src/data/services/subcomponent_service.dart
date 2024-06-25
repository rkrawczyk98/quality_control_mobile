import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/subcomponent_models.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class SubcomponentService {
  final String baseUrl = 'http://172.22.175.245:8080/subcomponents';
  late http.Client httpClient;

  SubcomponentService(AuthProvider authProvider) {
    httpClient = AuthenticatedHttpClient(http.Client(), authProvider);
  }

  Future<List<Subcomponent>> fetchSubcomponents() async {
    final response = await httpClient.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((s) => Subcomponent.fromJson(s as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load subcomponents');
    }
  }

  Future<Subcomponent> fetchSubcomponent(int id) async {
    final response = await httpClient.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Subcomponent.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load subcomponent');
    }
  }

  Future<Subcomponent> createSubcomponent(CreateSubcomponentDto dto) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 201) {
      return Subcomponent.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create subcomponent');
    }
  }

  Future<Subcomponent> updateSubcomponent(int id, UpdateSubcomponentDto dto) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return Subcomponent.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update subcomponent');
    }
  }

  Future<void> deleteSubcomponent(int id) async {
    final response = await httpClient.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete subcomponent');
    }
  }
}
