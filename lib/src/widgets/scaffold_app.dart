import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/screens/component_panel/component_screen.dart';
import 'package:quality_control_mobile/src/screens/auth/login_screen.dart';
import 'package:quality_control_mobile/src/services/auth_service.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final List<Widget> tabs;
  final List<Widget> children;

  const AppScaffold({
    Key? key,
    required this.title,
    required this.tabs,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, style: TextStyle(fontSize: 20)),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.green,
            tabs: tabs,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Image.asset(
                    'assets/images/flutter_logo.png'), // Dodaj swoje logo
              ),
              ListTile(
                title: const Text('Zarządzanie komponentami'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ComponentScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Ustawienia'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Panel administratora'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              // ListTile(
              //   title: const Text('Pomoc'),
              //   onTap: () {},
              // ),
              ListTile(
                leading: Icon(Icons.logout),
                title: const Text('Wyloguj'),
                onTap: () async {
                  await _showLogoutDialog(context, AuthService());
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: children,
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(
      BuildContext context, AuthService authService) async {
    final shouldLogoutAllDevices = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wylogowanie'),
          content:
              const Text('Czy chcesz wylogować się ze wszystkich urządzeń?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Nie'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Tak'),
            ),
          ],
        );
      },
    );

    if (shouldLogoutAllDevices != null) {
      if (shouldLogoutAllDevices) {
        await authService.logout();
      } else {
        await authService.logoutSingleDevice();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
