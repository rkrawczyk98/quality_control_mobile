import 'dart:convert';
import 'package:http/http.dart' as http;
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

class Customer {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime lastModified;
  final List<Delivery>? deliveries;

  Customer({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.lastModified,
    this.deliveries,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deliveries: json['deliveries'] != null
          ? (json['deliveries'] as List).map((i) => Delivery.fromJson(i)).toList()
          : null,
    );
  }
}

class Delivery {
  final int id;
  final String number;
  final DateTime deliveryDate;
  final DateTime creationDate;
  final DateTime lastModified;

  Delivery({
    required this.id,
    required this.number,
    required this.deliveryDate,
    required this.creationDate,
    required this.lastModified,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      number: json['number'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
    );
  }
}

class CreateCustomerDto {
  final String name;

  CreateCustomerDto({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class UpdateCustomerDto {
  final String? name;

  UpdateCustomerDto({this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class DeleteCustomerDto {
  final int id;

  DeleteCustomerDto({required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
