import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/user_provider.dart';
import 'package:quality_control_mobile/src/models/user_models.dart';

class ChangePasswordScreen extends StatefulWidget {
  final int userId;

  const ChangePasswordScreen({super.key, required this.userId});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _currentPassword;
  late String _newPassword;

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      UpdateUserDto updateUserDto = UpdateUserDto(currentPassword: _currentPassword, newPassword: _newPassword);
      await Provider.of<UserProvider>(context, listen: false)
          .updateUser(widget.userId, updateUserDto);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zmień hasło'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Obecne hasło',),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać obecne hasło';
                  }
                  return null;
                },
                onChanged: (value) => _currentPassword = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nowe hasło'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać nowe hasło';
                  }
                  return null;
                },
                onChanged: (value) => _newPassword = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                child: const Text('Zmień hasło'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
