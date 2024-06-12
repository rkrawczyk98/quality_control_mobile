import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/models/delivery_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryService {
  final String baseUrl = 'http://172.22.175.245:8080/deliveries';
  String? _jwtToken;

  Future<void> _loadAuthToken() async {
    if (_jwtToken == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _jwtToken = prefs.getString('access_token');
    }
  }

  Future<List<Delivery>> fetchDeliveries() async {
    await _loadAuthToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $_jwtToken', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List).map((data) => Delivery.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load deliveries');
    }
  }

  Future<Delivery> fetchDelivery(int id) async {
    await _loadAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $_jwtToken', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Delivery.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load delivery');
    }
  }

  Future<Delivery> createDelivery(CreateDeliveryDto createDeliveryDto) async {
    await _loadAuthToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $_jwtToken', 'Content-Type': 'application/json'},
      body: jsonEncode(createDeliveryDto.toJson()),
    );

    if (response.statusCode == 201) {
      return Delivery.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create delivery: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteDelivery(int id) async {
    await _loadAuthToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $_jwtToken', 'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete delivery');
    }
  }
}