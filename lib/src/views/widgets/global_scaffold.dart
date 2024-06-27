import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/controllers/auth_controller.dart';
import 'package:quality_control_mobile/src/views/screens/auth/login_screen.dart';
import 'package:quality_control_mobile/src/views/screens/component/component_screen.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_screen.dart';

class GlobalScaffold extends StatelessWidget {
  final Widget child;
  final AppBar? appBar; // Dodanie opcjonalnego AppBar
  final FloatingActionButton? floatingActionButton; // Opcjonalny FAB
  final bool showFAB;

  const GlobalScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton, // Przekazywanie FAB jako opcjonalny parametr
    this.showFAB = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: child,
      floatingActionButton: showFAB
          ? buildSpeedDial(context)
          : null, //floatingActionButton: floatingActionButton ?? buildSpeedDial(context),
      drawer: buildDrawer(context),
    );
  }

  SpeedDial buildSpeedDial(BuildContext context) {
    return SpeedDial(
      icon: Icons.reorder, //Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      activeBackgroundColor: Colors.red,
      activeForegroundColor: Colors.white,
      buttonSize: const Size(56, 56),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Naciśnij aby rozwinąć',
      // heroTag: 'speed-dial-hero-tag',
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.local_shipping_outlined,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
          label: 'Panel dostaw',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DeliveryScreen()),
          ),
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.view_in_ar_sharp,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          label: 'Panel komponentów',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComponentScreen()),
          ),
        ),
      ],
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
            child: Image.asset(
                'assets/images/flutter_logo.png'), // Dodaj swoje logo
          ),
          // ListTile(
          //   title: const Text('Zarządzanie komponentami'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const ComponentScreen()),
          //     );
          //   },
          // ),
          ListTile(
            title: const Text('Panel administratora'),
            onTap: () => Navigator.pushNamed(
                  context, '/admin-panel'),
          ),
          ListTile(
            title: const Text('Ustawienia'),
            onTap: () => Navigator.pushNamed(
                  context, '/settings'),
          ),
          ListTile(
            title: const Text('O Aplikacji'),
            onTap: () => Navigator.pushNamed(
                  context, '/about-app'),
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
        await Provider.of<AuthController>(context, listen: false)
            .logoutAllDevices();
      } else {
        await Provider.of<AuthController>(context, listen: false)
            .logoutSingleDevice();
      }
      // if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
