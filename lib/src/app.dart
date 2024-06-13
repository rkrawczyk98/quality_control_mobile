import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quality_control_mobile/src/views/widgets/global_scaffold.dart';
import 'views/screens/auth/login_screen.dart';
import 'views/screens/delivery/delivery_screen.dart';
import 'views/screens/component/component_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quality Control Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const GlobalScaffold(showFAB: false, child: LoginScreen()),
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
