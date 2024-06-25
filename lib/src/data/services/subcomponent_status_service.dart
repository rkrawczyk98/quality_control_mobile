import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/subcomponent_status_models.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class SubcomponentStatusService {
  final String baseUrl = 'http://172.22.175.245:8080/subcomponent-statuses';
  late http.Client httpClient;

  SubcomponentStatusService(AuthProvider authProvider) {
    httpClient = AuthenticatedHttpClient(http.Client(), authProvider);
  }

  Future<List<SubcomponentStatus>> fetchSubcomponentStatuses() async {
    final response = await httpClient.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((item) => SubcomponentStatus.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load subcomponent statuses');
    }
  }

  Future<SubcomponentStatus> fetchSubcomponentStatus(int id) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return SubcomponentStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load subcomponent status');
    }
  }

  Future<SubcomponentStatus> createSubcomponentStatus(
      CreateSubcomponentStatusDto dto) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 201) {
      return SubcomponentStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create subcomponent status');
    }
  }

  Future<void> deleteSubcomponentStatus(int id) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete subcomponent status');
    }
  }

  Future<SubcomponentStatus> updateSubcomponentStatus(
      int id, UpdateSubcomponentStatusDto dto) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return SubcomponentStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update subcomponent status');
    }
  }
}
