import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/user_provider.dart';
import 'package:quality_control_mobile/src/models/user_models.dart';

class UserDetailsScreen extends StatelessWidget {
  final int userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final User user = userProvider.users.firstWhere((user) => user.id == userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły użytkownika'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: const Text('ID'),
                subtitle: Text('${user.id}'),
              ),
              ListTile(
                title: const Text('Nazwa użytkownika'),
                subtitle: Text(user.username),
              ),
              ListTile(
                title: const Text('Data utworzenia'),
                subtitle: Text(user.creationDate.toIso8601String()),
              ),
              ListTile(
                title: const Text('Ostatnia modyfikacja'),
                subtitle: Text(user.lastModified.toIso8601String()),
              ),
              ListTile(
                title: const Text('Status'),
                subtitle: Text(user.isDeleted ? 'Usunięty' : 'Aktywny'),
              ),
              // ElevatedButton(
              //   onPressed: () => Navigator.pushNamed(context, '/edit-user',
              //       arguments: user.id),
              //   child: const Text('Edytuj'),
              // ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/change-password',
                    arguments: user.id),
                child: const Text('Zmień hasło'),
              ),
            ],
          ),
        ),
      )
    );
  }
}
