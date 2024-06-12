import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/controllers/auth_controller.dart';
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/views/screens/auth/login_screen.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_screen.dart';
import 'package:quality_control_mobile/src/views/screens/component/component_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:quality_control_mobile/src/views/widgets/global_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pl', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider(create: (context) => AuthController(Provider.of<AuthProvider>(context, listen: false))),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const GlobalScaffold(child: LoginScreen()),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl', ''),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome to the Quality Control App'),
      ),
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
      buttonSize: const Size(56, 56),
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
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.delivery_dining),
          backgroundColor: Colors.red,
          label: 'Deliveries',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DeliveryScreen()),
          ),
        ),
        SpeedDialChild(
          child: const Icon(Icons.settings),
          backgroundColor: Colors.blue,
          label: 'Components',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComponentScreen()),
          ),
        ),
      ],
    );
  }
}
