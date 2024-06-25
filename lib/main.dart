import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/app.dart';
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_subcomponent_provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_type_provider.dart';
import 'package:quality_control_mobile/src/data/providers/customer_provider.dart';
import 'package:quality_control_mobile/src/data/providers/delivery_provider.dart';
import 'package:quality_control_mobile/src/data/providers/subcomponent_provider.dart';
import 'package:quality_control_mobile/src/data/providers/subcomponent_status_provider.dart';
import 'package:quality_control_mobile/src/data/services/auth_service.dart';
import 'src/data/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pl', null);

  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (context) => ComponentProvider(
              Provider.of<AuthProvider>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => ComponentSubcomponentProvider(
              Provider.of<AuthProvider>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => ComponentTypeProvider(
              Provider.of<AuthProvider>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerProvider(
              Provider.of<AuthProvider>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => DeliveryProvider(
              Provider.of<AuthProvider>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => SubcomponentStatusProvider(
              Provider.of<AuthProvider>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => SubcomponentProvider(
              Provider.of<AuthProvider>(context, listen: false)),
        ),
        Provider(
          create: (context) =>
              AuthController(Provider.of<AuthProvider>(context, listen: false),authService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
