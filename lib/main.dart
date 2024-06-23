import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/app.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_subcomponent_provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_type_provider.dart';
import 'package:quality_control_mobile/src/data/providers/customer_provider.dart';
import 'package:quality_control_mobile/src/data/providers/delivery_provider.dart';
import 'package:quality_control_mobile/src/data/providers/subcomponent_status_provider.dart';
import 'src/data/controllers/auth_controller.dart';
import 'src/data/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pl', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ComponentProvider()),
        ChangeNotifierProvider(create: (_) => ComponentSubcomponentProvider()),
        ChangeNotifierProvider(create: (_) => ComponentTypeProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
        ChangeNotifierProvider(create: (_) => SubcomponentStatusProvider()),
        Provider(
            create: (context) => AuthController(
                Provider.of<AuthProvider>(context, listen: false))),
      ],
      child: const MyApp(),
    ),
  );
}
