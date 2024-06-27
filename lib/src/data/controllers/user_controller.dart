import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/data/services/user_service.dart';
import 'package:quality_control_mobile/src/models/user_models.dart';

class UserController {
  final UserService _service;

  UserController(AuthProvider authProvider)
      : _service = UserService(authProvider);

  Future<List<User>> getUsers() async {
    return await _service.findAllUsers();
  }

  Future<User> createUser(CreateUserDto createUserDto) async {
    return await _service.createUser(createUserDto);
  }

  Future<User> updateUser(int id, UpdateUserDto updateUserDto) async {
    return await _service.updateUser(id, updateUserDto);
  }

  Future<void> deleteUser(int id) async {
    await _service.deleteUser(id);
  }
}
