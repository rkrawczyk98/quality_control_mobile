import 'package:flutter/material.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  Widget build(BuildContext context) {
    // Przykładowa lista użytkowników
    final List<Map<String, dynamic>> users = [
      {"name": "John Doe", "status": "Active"},
      {"name": "Jane Smith", "status": "Inactive"},
      {"name": "Alice Johnson", "status": "Active"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admina'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index]['name']),
            subtitle: Text('Status: ${users[index]['status']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Implementacja edycji użytkownika
                  },
                ),
                IconButton(
                  icon: Icon(
                    users[index]['status'] == "Active"
                        ? Icons.lock_open
                        : Icons.lock_outline,
                  ),
                  onPressed: () {
                    // Implementacja zmiany statusu użytkownika
                    setState(() {
                      users[index]['status'] = users[index]['status'] == "Active"
                          ? "Inactive"
                          : "Active";
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              // Navigacja do szczegółów użytkownika
            },
          );
        },
      ),
    );
  }
}
