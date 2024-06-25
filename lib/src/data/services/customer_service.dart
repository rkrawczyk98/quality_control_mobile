import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/customer_models.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class CustomerService {
  final String baseUrl = 'http://172.22.175.245:8080/customers';
  late http.Client httpClient;

  CustomerService(AuthProvider authProvider) {
    httpClient = AuthenticatedHttpClient(http.Client(), authProvider);
  }

  Future<List<Customer>> fetchCustomers() async {
    final response = await httpClient.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body) as List;
      return jsonResponse
          .map(
              (customer) => Customer.fromJson(customer as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load customers: ${response.reasonPhrase}');
    }
  }

  Future<Customer> fetchCustomer(int id) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Customer.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load customer: ${response.reasonPhrase}');
    }
  }

  Future<Customer> createCustomer(CreateCustomerDto createCustomerDto) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(createCustomerDto.toJson()),
    );

    if (response.statusCode == 201) {
      return Customer.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create customer: ${response.reasonPhrase}');
    }
  }

  Future<Customer> updateCustomer(
      int id, UpdateCustomerDto updateCustomerDto) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateCustomerDto.toJson()),
    );

    if (response.statusCode == 200) {
      return Customer.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update customer: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteCustomer(int id) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete customer: ${response.reasonPhrase}');
    }
  }
}
