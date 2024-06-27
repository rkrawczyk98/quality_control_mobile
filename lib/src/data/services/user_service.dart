import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/user_models.dart';
import 'package:quality_control_mobile/src/utils/middlewares/authenticated_client.dart';

class UserService {
  final String baseUrl = 'http://172.22.175.245:8080/user';
  late http.Client httpClient;
  
  UserService(AuthProvider authProvider) {
    httpClient = AuthenticatedHttpClient(http.Client(), authProvider);
  }

  Future<List<User>> findAllUsers() async {
    final response = await httpClient.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> createUser(CreateUserDto createUserDto) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(createUserDto.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> updateUser(int id, UpdateUserDto updateUserDto) async {
    final response = await httpClient.patch(
      Uri.parse('$baseUrl/change-password/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateUserDto.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await httpClient.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
