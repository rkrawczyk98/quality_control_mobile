import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/user_controller.dart';
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/user_models.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  final UserController _controller;

  UserProvider(AuthProvider authProvider)
      : _controller = UserController(authProvider) {
    fetchUsers();
  }

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    try {
      _users = await _controller.getUsers();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch users: $e');
    }
  }

  Future<void> addUser(CreateUserDto createUserDto) async {
    try {
      User newUser = await _controller.createUser(createUserDto);
      _users.add(newUser);
      notifyListeners();
    } catch (e) {
      print('Failed to add user: $e');
    }
  }

  Future<void> updateUser(int id, UpdateUserDto updateUserDto) async {
    try {
      User updatedUser = await _controller.updateUser(id, updateUserDto);
      int index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
        notifyListeners();
      }
    } catch (e) {
      print('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _controller.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      notifyListeners();
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }
}
