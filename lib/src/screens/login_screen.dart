import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/screens/delivery_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quality_control_mobile/src/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedUsername = prefs.getString('saved_username');
    final String? savedPassword = prefs.getString('saved_password');
    final bool rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      setState(() {
        _usernameController.text = savedUsername ?? '';
        _passwordController.text = savedPassword ?? '';
        _rememberMe = rememberMe;
      });
    }
  }

  Future<void> _saveCredentials(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_username', username);
    await prefs.setString('saved_password', password);
    await prefs.setBool('remember_me', _rememberMe);
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.login(
          _usernameController.text,
          _passwordController.text,
        );

        if (_rememberMe) {
          _saveCredentials(_usernameController.text, _passwordController.text);
        } else {
          _clearSavedCredentials();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DeliveryScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logowanie nieudane: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _clearSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_username');
    await prefs.remove('saved_password');
    await prefs.setBool('remember_me', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logowanie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration:
                    const InputDecoration(labelText: 'Nazwa użytkownika'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Podaj nazwę użytwkonika';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Hasło'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Podaj hasło';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('Zapamiętaj mnie'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Zaloguj'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
