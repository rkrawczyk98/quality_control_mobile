import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';
import 'package:quality_control_mobile/src/models/delivery_models.dart';

class DeliveryService {
  final String baseUrl = 'http://172.22.175.245:8080/deliveries';
  late http.Client httpClient;

  DeliveryService(AuthProvider authProvider) {
    httpClient = AuthenticatedHttpClient(http.Client(), authProvider);
  }

  Future<List<Delivery>> fetchDeliveries() async {
    final response = await httpClient.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Delivery.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load deliveries');
    }
  }

  Future<Delivery> fetchDelivery(int id) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      return Delivery.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load delivery');
    }
  }

  Future<Delivery> createDelivery(CreateDeliveryDto createDeliveryDto) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(createDeliveryDto.toJson()),
    );

    if (response.statusCode == 201) {
      return Delivery.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create delivery: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteDelivery(int id) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete delivery');
    }
  }
}
