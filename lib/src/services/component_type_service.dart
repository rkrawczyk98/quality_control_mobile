import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ComponentTypeService {
  final String baseUrl = 'http://172.22.175.245:8080/component-types';
  String? _jwtToken;

  Future<void> _loadAuthToken() async {
    if (_jwtToken == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _jwtToken = prefs.getString('access_token');
    }
  }

  Future<List<ComponentType>> fetchComponentTypes() async {
    await _loadAuthToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
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
    await _loadAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
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
    await _loadAuthToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
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
    await _loadAuthToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
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
    await _loadAuthToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete component type: ${response.reasonPhrase}');
    }
  }
}

class ComponentType {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  ComponentType({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory ComponentType.fromJson(Map<String, dynamic> json) {
    return ComponentType(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

class CreateComponentTypeDto {
  final String name;

  CreateComponentTypeDto({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class UpdateComponentTypeDto {
  final String? name;

  UpdateComponentTypeDto({this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class DeleteComponentTypeDto {
  final int id;

  DeleteComponentTypeDto({required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
