import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_screen.dart';
import 'package:quality_control_mobile/src/views/screens/component/component_screen.dart';

class GlobalScaffold extends StatelessWidget {
  final Widget child;

  const GlobalScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: buildSpeedDial(context),
    );
  }

  SpeedDial buildSpeedDial(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      activeBackgroundColor: Colors.red,
      activeForegroundColor: Colors.white,
      buttonSize: const Size(56,56),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.delivery_dining),
          backgroundColor: Colors.red,
          label: 'Deliveries',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeliveryScreen()),
          ),
        ),
        SpeedDialChild(
          child: Icon(Icons.settings),
          backgroundColor: Colors.blue,
          label: 'Components',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComponentScreen()),
          ),
        ),
      ],
    );
  }
}
