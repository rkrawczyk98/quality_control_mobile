import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/user_provider.dart';
import 'package:quality_control_mobile/src/models/user_models.dart';

class EditUserScreen extends StatefulWidget {
  final int userId;

  const EditUserScreen({super.key, required this.userId});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var user =
        userProvider.users.firstWhere((user) => user.id == widget.userId);
    setState(() {
      _user = user;
      _username = _user!.username;
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate() && _user != null) {
      UpdateUserDto updateUserDto =
          UpdateUserDto(currentPassword: '', newPassword: _username);
      await Provider.of<UserProvider>(context, listen: false)
          .updateUser(widget.userId, updateUserDto);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj użytkownika'),
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _username,
                      decoration:
                          const InputDecoration(labelText: 'Nazwa użytkownika'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nazwa użytkownika nie może być pusta';
                        }
                        return null;
                      },
                      onChanged: (value) => _username = value,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text('Zapisz zmiany'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
