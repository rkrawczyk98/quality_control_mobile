import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ComponentService {
  final String baseUrl = 'http://172.22.175.245:8080/components';
  String? _jwtToken;

  Future<void> _loadAuthToken() async {
    if (_jwtToken == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _jwtToken = prefs.getString('access_token');
    }
  }

  Future<List<Component>> fetchComponents() async {
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
      return jsonResponse.map((component) => Component.fromJson(component as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load components');
    }
  }

  Future<Component> fetchComponent(int id) async {
    await _loadAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Component.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load component');
    }
  }

  Future<Component> createComponent(CreateComponentDto createComponentDto) async {
    await _loadAuthToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(createComponentDto.toJson()),
    );

    if (response.statusCode == 201) {
      return Component.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      var errorResponse = json.decode(response.body);
      throw Exception('Failed to create component: ${errorResponse['message']}');
    }
  }

  Future<void> deleteComponent(int id) async {
    await _loadAuthToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete component');
    }
  }
}

class Component {
  final int id;
  final String name;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final int size;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  Component({
    required this.id,
    required this.name,
    this.controlDate,
    this.productionDate,
    required this.size,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      id: json['id'],
      name: json['name'],
      controlDate: json['controlDate'] != null ? DateTime.parse(json['controlDate']) : null,
      productionDate: json['productionDate'] != null ? DateTime.parse(json['productionDate']) : null,
      size: json['size'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

class CreateComponentDto {
  final String name;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final int deliveryId;
  final double size;

  CreateComponentDto({
    required this.name,
    this.controlDate,
    this.productionDate,
    required this.deliveryId,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'controlDate': controlDate?.toIso8601String(),
      'productionDate': productionDate?.toIso8601String(),
      'deliveryId': deliveryId,
      'size': size,
    };
  }
}
