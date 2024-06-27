import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkTheme = true;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Ciemny motyw'),
            subtitle: const Text('Włącz lub wyłącz ciemny motyw'),
            value: _darkTheme,
            onChanged: (bool value) {
              setState(() {
                _darkTheme = value;
              });
              // Dodatkowo zaimplementuj logikę zmiany motywu w aplikacji
            },
          ),
          SwitchListTile(
            title: const Text('Powiadomienia'),
            subtitle: const Text('Zarządzaj powiadomieniami aplikacji'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // Implementacja logiki włączania/wyłączania powiadomień
            },
          ),
          ListTile(
            title: const Text('Zarządzaj kontem'),
            subtitle: const Text('Przejdź do ustawień konta'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigacja do ekranu zarządzania kontem
            },
          ),
          ListTile(
            title: const Text('Informacje o aplikacji'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              // Możesz tutaj dodać nawigację do ekranu O aplikacji
            },
          ),
        ],
      ),
    );
  }
}
