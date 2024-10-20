import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/user_provider.dart';
import 'package:quality_control_mobile/src/models/user_models.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      CreateUserDto newUser = CreateUserDto(username: _username, password: _password);
      try {
        await Provider.of<UserProvider>(context, listen: false).addUser(newUser);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Błąd podczas dodawania użytkownika: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj użytkownika'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nazwa użytkownika'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać nazwę użytkownika';
                  }
                  return null;
                },
                onChanged: (value) => _username = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hasło'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać hasło';
                  }
                  return null;
                },
                onChanged: (value) => _password = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Dodaj użytkownika'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
