import 'dart:convert';
import 'package:http/http.dart' as http;
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
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((delivery) => Delivery.fromJson(delivery as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load deliveries');
    }
  }

  Future<Delivery> fetchDelivery(int id) async {
    await _loadAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Delivery.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load delivery');
    }
  }

Future<Delivery> createDelivery(CreateDeliveryDto createDeliveryDto) async {
  await _loadAuthToken();
  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(createDeliveryDto.toJson()),
    );

    if (response.statusCode == 201) {
      return Delivery.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create delivery: ${response.body}');
    }
  } catch (e) {
    print('Error creating delivery: $e');
    rethrow;  // Rzuć ponownie wyjątek do obsługi na wyższym poziomie
  }
}

  Future<void> deleteDelivery(int id) async {
    await _loadAuthToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $_jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete delivery');
    }
  }
}

class Delivery {
  final int id;
  final String number;
  final CreatedByUserResponseDto createdByUser;
  final ComponentTypeResponseDto componentType;
  final DeliveryStatusResponseDto status;
  final CustomerResponseDto customer;
  final DateTime creationDate;
  final DateTime deliveryDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  Delivery({
    required this.id,
    required this.number,
    required this.createdByUser,
    required this.componentType,
    required this.status,
    required this.customer,
    required this.creationDate,
    required this.deliveryDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      number: json['number'],
      createdByUser: CreatedByUserResponseDto.fromJson(json['createdByUser']),
      componentType: ComponentTypeResponseDto.fromJson(json['componentType']),
      status: DeliveryStatusResponseDto.fromJson(json['status']),
      customer: CustomerResponseDto.fromJson(json['customer']),
      creationDate: DateTime.parse(json['creationDate']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}

class CreateDeliveryDto {
  final int componentTypeId;
  final int customerId;
  final String deliveryDate;

  CreateDeliveryDto({required this.componentTypeId, required this.customerId, required this.deliveryDate});

  Map<String, dynamic> toJson() {
    return {
      'componentTypeId': componentTypeId,
      'customerId': customerId,
      'deliveryDate': deliveryDate,
    };
  }
}

class CreatedByUserResponseDto {
  final int id;
  final String username;

  CreatedByUserResponseDto({
    required this.id,
    required this.username,
  });

  factory CreatedByUserResponseDto.fromJson(Map<String, dynamic> json) {
    return CreatedByUserResponseDto(
      id: json['id'],
      username: json['username'],
    );
  }
}

class ComponentTypeResponseDto {
  final int id;
  final String name;

  ComponentTypeResponseDto({
    required this.id,
    required this.name,
  });

  factory ComponentTypeResponseDto.fromJson(Map<String, dynamic> json) {
    return ComponentTypeResponseDto(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DeliveryStatusResponseDto {
  final int id;
  final String name;

  DeliveryStatusResponseDto({
    required this.id,
    required this.name,
  });

  factory DeliveryStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return DeliveryStatusResponseDto(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CustomerResponseDto {
  final int id;
  final String name;

  CustomerResponseDto({
    required this.id,
    required this.name,
  });

  factory CustomerResponseDto.fromJson(Map<String, dynamic> json) {
    return CustomerResponseDto(
      id: json['id'],
      name: json['name'],
    );
  }
}