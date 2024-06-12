import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/models/customer_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerService {
  final String baseUrl = 'http://172.22.175.245:8080/customers';
  String? _jwtToken;

  Future<void> _loadAuthToken() async {
    if (_jwtToken == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _jwtToken = prefs.getString('access_token');
    }
  }

  Future<List<Customer>> fetchCustomers() async {
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
      return jsonResponse.map((customer) => Customer.fromJson(customer as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load customers: ${response.reasonPhrase}');
    }
  }

  Future<Customer> fetchCustomer(int id) async {
    await _loadAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load customer: ${response.reasonPhrase}');
    }
  }

  Future<Customer> createCustomer(CreateCustomerDto createCustomerDto) async {
    await _loadAuthToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(createCustomerDto.toJson()),
    );

    if (response.statusCode == 201) {
      return Customer.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create customer: ${response.reasonPhrase}');
    }
  }

  Future<Customer> updateCustomer(int id, UpdateCustomerDto updateCustomerDto) async {
    await _loadAuthToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateCustomerDto.toJson()),
    );

    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update customer: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteCustomer(int id) async {
    await _loadAuthToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete customer: ${response.reasonPhrase}');
    }
  }
}