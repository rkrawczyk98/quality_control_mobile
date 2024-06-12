import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quality_control_mobile/src/views/screens/auth/login_screen.dart';
import 'package:quality_control_mobile/src/views/screens/component/component_screen.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quality Control Mobile',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LoginScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl', ''),
      ],
      routes: {
        '/login': (context) => const LoginScreen(),
        '/delivery': (context) => const DeliveryScreen(),
        '/components': (context) => const ComponentScreen(),
      },
    );
  }
}
