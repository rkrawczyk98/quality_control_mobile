import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/user_provider.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  void _confirmDelete(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potwierdzenie'),
          content: const Text('Czy na pewno chcesz usunąć tego użytkownika?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop(); // Zamknij okno dialogowe
              },
            ),
            TextButton(
              child: const Text('Usuń'),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false)
                    .deleteUser(userId); // Usuwanie użytkownika
                Navigator.of(context).pop(); // Zamknij okno dialogowe
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Panel Administratora'),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).fetchUsers();
            },
          ),
        ]),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.users.length,
            itemBuilder: (context, index) {
              final user = provider.users[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nazwa użytkownika', style: TextStyle(color: Colors.white),),
                    Text(user.username, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                subtitle: Text('ID: ${user.id}', style: const TextStyle(color: Colors.grey)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IconButton(
                    //   icon: const Icon(Icons.edit),
                    //   onPressed: () => Navigator.pushNamed(
                    //       context, '/edit-user',
                    //       arguments: user.id),
                    // ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                      ),
                      onPressed: () => _confirmDelete(context, user.id),
                    ),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, '/user-details',
                    arguments: user.id),
              );
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () => Navigator.pushNamed(context, '/add-user'),
          shape: const CircleBorder(),
          tooltip: 'Dodaj nowego użytkownika',
          child: const Icon(Icons.add, size: 36),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
