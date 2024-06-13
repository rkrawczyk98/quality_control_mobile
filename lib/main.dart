import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/app.dart';
import 'src/data/controllers/auth_controller.dart';
import 'src/data/providers/auth_provider.dart';

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