import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/complaint_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/environmental_provider.dart';

class AquaPulseApp extends StatelessWidget {
  const AquaPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ComplaintProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => EnvironmentalProvider()),
      ],
      child: MaterialApp(
        title: 'AquaPulse – Water Leakage Reporting',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
