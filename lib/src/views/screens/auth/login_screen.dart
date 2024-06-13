import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/auth_controller.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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

  Future<void> _clearSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_username');
    await prefs.remove('saved_password');
    await prefs.setBool('remember_me', false);
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<AuthController>(context, listen: false).login(
          _usernameController.text,
          _passwordController.text,
        );

        if (_rememberMe) {
          await _saveCredentials(
              _usernameController.text, _passwordController.text);
        } else {
          await _clearSavedCredentials();
        }

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DeliveryScreen()),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logowanie nieudane: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logowanie'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    labelText: 'Nazwa użytkownika',
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Podaj nazwę użytkownika';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: 'Hasło',
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    border: OutlineInputBorder()),
                obscureText: true,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Podaj hasło';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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