import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_theme.dart';
import 'constants/app_strings.dart';
import 'providers/auth_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/delivery_provider.dart';
import 'providers/billing_provider.dart';
import 'providers/product_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/customer/customer_dashboard.dart';

void main() {
  runApp(const DairyTrackApp());
}

class DairyTrackApp extends StatelessWidget {
  const DairyTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
        ChangeNotifierProvider(create: (_) => BillingProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          // User is logged in, navigate to appropriate dashboard
          if (authProvider.isAdmin) {
            return const AdminDashboard();
          } else {
            return const CustomerDashboard();
          }
        } else {
          // User is not logged in, show login screen
          return const LoginScreen();
        }
      },
    );
  }
}
