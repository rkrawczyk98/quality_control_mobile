import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quality_control_mobile/src/views/screens/admin/admin_panel_screen.dart';
import 'package:quality_control_mobile/src/views/screens/component/add_component_to_delivery_screen.dart';
import 'package:quality_control_mobile/src/views/screens/component/component_details_screen.dart';
import 'package:quality_control_mobile/src/views/screens/component/component_manage_screen.dart';
import 'package:quality_control_mobile/src/views/screens/core-app/about_app_screen.dart';
import 'package:quality_control_mobile/src/views/screens/core-app/settings_screen.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_contents_screen.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_details_screen.dart';
import 'package:quality_control_mobile/src/views/screens/user/add_user_screen.dart';
import 'package:quality_control_mobile/src/views/screens/user/change_password_screen.dart';
import 'package:quality_control_mobile/src/views/screens/user/user_details_screen.dart';
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
        '/delivery-details': (context) {
          final int deliveryId =
              ModalRoute.of(context)!.settings.arguments as int;
          return DeliveryDetailsScreen(deliveryId: deliveryId);
        },
        '/delivery-contents': (context) {
          final int deliveryId =
              ModalRoute.of(context)!.settings.arguments as int;
          return DeliveryContentsScreen(deliveryId: deliveryId);
        },
        '/create-component-deliveryId': (context) {
          final int deliveryId =
              ModalRoute.of(context)!.settings.arguments as int;
          return AddComponentToDeliveryScreen(deliveryId: deliveryId);
        },
        '/component-details': (context) {
          final int componentId =
              ModalRoute.of(context)!.settings.arguments as int;
          return ComponentDetailsScreen(componentId: componentId);
        },
        '/component-manage': (context) {
          final int componentId =
              ModalRoute.of(context)!.settings.arguments as int;
          return ComponentManageScreen(componentId: componentId);
        },
        '/admin-panel': (context) {
          return const AdminPanelScreen();
        },
        '/settings': (context) {
          return const SettingsScreen();
        },
        '/about-app': (context) {
          return const AboutAppScreen();
        },
        // '/edit-user': (context) {
        //   final int userId = ModalRoute.of(context)!.settings.arguments as int;
        //   return EditUserScreen(userId: userId);
        // },
        '/user-details': (context) {
          final int userId = ModalRoute.of(context)!.settings.arguments as int;
          return UserDetailsScreen(userId: userId);
        },
        '/change-password': (context) {
          final int userId = ModalRoute.of(context)!.settings.arguments as int;
          return ChangePasswordScreen(userId: userId);
        },
        '/add-user': (context) {
          return const AddUserScreen();
        },
      },
    );
  }
}
