import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/controllers/auth_controller.dart';
import 'package:quality_control_mobile/src/views/screens/component/component_screen.dart';
import 'package:quality_control_mobile/src/views/screens/auth/login_screen.dart';

class AppScaffold extends StatefulWidget {
  final String title;
  final List<Widget> tabs;
  final List<Widget> children;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.title,
    required this.tabs,
    required this.children,
    this.floatingActionButton,
  });

  @override
  AppScaffoldState createState() => AppScaffoldState();
}

class AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: const TextStyle(fontSize: 20)),
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
            tabs: widget.tabs,
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
        drawer: buildDrawer(context),
        body: TabBarView(
          children: widget.children,
        ),
        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Image.asset('assets/images/flutter_logo.png'), // Dodaj swoje logo
          ),
          ListTile(
            title: const Text('Zarządzanie komponentami'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ComponentScreen()),
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
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Wyloguj'),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogoutAllDevices = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wylogowanie'),
          content: const Text('Czy chcesz wylogować się ze wszystkich urządzeń?'),
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
        await Provider.of<AuthController>(context, listen: false).logoutAllDevices();
      } else {
        await Provider.of<AuthController>(context, listen: false).logoutSingleDevice();
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}