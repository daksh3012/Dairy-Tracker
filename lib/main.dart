import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'features/admin/presentation/pages/admin_dashboard_page.dart';
import 'features/customer/presentation/pages/customer_dashboard_page.dart';
import 'features/admin/presentation/providers/admin_provider.dart';
import 'features/customer/presentation/providers/customer_provider.dart';
import 'features/admin/data/repositories/admin_repository_impl.dart';
import 'features/customer/data/repositories/customer_repository_impl.dart';
import 'features/admin/domain/usecases/get_dashboard_stats_usecase.dart';
import 'features/admin/domain/usecases/get_customers_usecase.dart'
    as admin_customers;
import 'features/admin/domain/usecases/get_deliveries_usecase.dart'
    as admin_deliveries;
import 'features/admin/domain/usecases/get_bills_usecase.dart' as admin_bills;
import 'features/customer/domain/usecases/get_customer_dashboard_usecase.dart';
import 'features/customer/domain/usecases/get_customer_deliveries_usecase.dart'
    as customer_deliveries;
import 'features/customer/domain/usecases/get_customer_bills_usecase.dart'
    as customer_bills;
import 'shared/services/mock_data_service.dart';

void main() {
  runApp(const DairyTrackApp());
}

class DairyTrackApp extends StatelessWidget {
  const DairyTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Mock data service
        Provider<MockDataService>(
          create: (_) => MockDataService(),
        ),
        // Admin providers
        Provider<AdminRepositoryImpl>(
          create: (context) => AdminRepositoryImpl(
            mockDataService: context.read<MockDataService>(),
          ),
        ),
        ChangeNotifierProvider<AdminProvider>(
          create: (context) => AdminProvider(
            getDashboardStatsUseCase: GetDashboardStatsUseCase(
              context.read<AdminRepositoryImpl>(),
            ),
            getCustomersUseCase: admin_customers.GetCustomersUseCase(
              context.read<AdminRepositoryImpl>(),
            ),
            getDeliveriesUseCase: admin_deliveries.GetDeliveriesUseCase(
              context.read<AdminRepositoryImpl>(),
            ),
            getBillsUseCase: admin_bills.GetBillsUseCase(
              context.read<AdminRepositoryImpl>(),
            ),
          ),
        ),
        // Customer providers
        Provider<CustomerRepositoryImpl>(
          create: (context) => CustomerRepositoryImpl(
            mockDataService: context.read<MockDataService>(),
          ),
        ),
        ChangeNotifierProvider<CustomerProvider>(
          create: (context) => CustomerProvider(
            getCustomerDashboardUseCase: GetCustomerDashboardUseCase(
              context.read<CustomerRepositoryImpl>(),
            ),
            getCustomerDeliveriesUseCase:
                customer_deliveries.GetCustomerDeliveriesUseCase(
              context.read<CustomerRepositoryImpl>(),
            ),
            getCustomerBillsUseCase: customer_bills.GetCustomerBillsUseCase(
              context.read<CustomerRepositoryImpl>(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Authentication wrapper with proper navigation
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isAuthenticated = false;
  bool _isAdmin = false;

  void _login(bool isAdmin) {
    setState(() {
      _isAuthenticated = true;
      _isAdmin = isAdmin;
    });
  }

  void _logout() {
    setState(() {
      _isAuthenticated = false;
      _isAdmin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return LoginScreen(onLogin: _login);
    }

    if (_isAdmin) {
      return AdminDashboardPage(onLogout: _logout);
    } else {
      return CustomerDashboardPage(onLogout: _logout);
    }
  }
}

/// Simple login screen
class LoginScreen extends StatefulWidget {
  final Function(bool isAdmin) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAdmin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App Logo/Title
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.local_drink,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.appName,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.appTagline,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Role Selection
                        Text(
                          'Select Role',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildRoleCard(
                                true,
                                'Admin',
                                Icons.admin_panel_settings,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildRoleCard(
                                false,
                                'Customer',
                                Icons.person,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            hintText: 'Enter your email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                widget.onLogin(_isAdmin);
                              }
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Demo Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.info.withOpacity(0.3),
                            ),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: AppColors.info,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Demo App',
                                    style: TextStyle(
                                      color: AppColors.info,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'This is a prototype with mock data. Enter any email and password (6+ characters) to login.',
                                style: TextStyle(
                                  color: AppColors.info,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(bool isAdmin, String title, IconData icon) {
    final isSelected = _isAdmin == isAdmin;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isAdmin = isAdmin;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
