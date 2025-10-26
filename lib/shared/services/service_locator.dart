import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

import '../features/admin/data/repositories/admin_repository_impl.dart';
import '../features/admin/domain/repositories/admin_repository.dart';
import '../features/admin/domain/usecases/get_dashboard_stats_usecase.dart';
import '../features/admin/domain/usecases/get_customers_usecase.dart';
import '../features/admin/domain/usecases/get_deliveries_usecase.dart';
import '../features/admin/domain/usecases/get_bills_usecase.dart';
import '../features/admin/presentation/providers/admin_provider.dart';

import '../features/customer/data/repositories/customer_repository_impl.dart';
import '../features/customer/domain/repositories/customer_repository.dart';
import '../features/customer/domain/usecases/get_customer_dashboard_usecase.dart';
import '../features/customer/domain/usecases/get_customer_deliveries_usecase.dart';
import '../features/customer/domain/usecases/get_customer_bills_usecase.dart';
import '../features/customer/presentation/providers/customer_provider.dart';

import '../shared/services/mock_data_service.dart';
import '../shared/services/local_storage_service.dart';

/// Service locator for dependency injection
final GetIt getIt = GetIt.instance;

class ServiceLocator {
  /// Initialize all dependencies
  static Future<void> init() async {
    // External dependencies
    await _initExternalDependencies();
    
    // Core services
    _initCoreServices();
    
    // Data sources
    _initDataSources();
    
    // Repositories
    _initRepositories();
    
    // Use cases
    _initUseCases();
    
    // Providers
    _initProviders();
  }
  
  /// Initialize external dependencies
  static Future<void> _initExternalDependencies() async {
    // SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    
    // Logger
    getIt.registerSingleton<Logger>(Logger());
  }
  
  /// Initialize core services
  static void _initCoreServices() {
    // Local Storage Service
    getIt.registerLazySingleton<LocalStorageService>(
      () => LocalStorageService(getIt<SharedPreferences>()),
    );
    
    // Mock Data Service
    getIt.registerLazySingleton<MockDataService>(
      () => MockDataService(),
    );
  }
  
  /// Initialize data sources
  static void _initDataSources() {
    // Data sources will be implemented here when API integration is added
    // For now, we're using mock data service
  }
  
  /// Initialize repositories
  static void _initRepositories() {
    // Auth Repository
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        mockDataService: getIt<MockDataService>(),
        localStorageService: getIt<LocalStorageService>(),
      ),
    );
    
    // Admin Repository
    getIt.registerLazySingleton<AdminRepository>(
      () => AdminRepositoryImpl(
        mockDataService: getIt<MockDataService>(),
      ),
    );
    
    // Customer Repository
    getIt.registerLazySingleton<CustomerRepository>(
      () => CustomerRepositoryImpl(
        mockDataService: getIt<MockDataService>(),
      ),
    );
  }
  
  /// Initialize use cases
  static void _initUseCases() {
    // Auth Use Cases
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    );
    
    getIt.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(getIt<AuthRepository>()),
    );
    
    getIt.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt<AuthRepository>()),
    );
    
    // Admin Use Cases
    getIt.registerLazySingleton<GetDashboardStatsUseCase>(
      () => GetDashboardStatsUseCase(getIt<AdminRepository>()),
    );
    
    getIt.registerLazySingleton<GetCustomersUseCase>(
      () => GetCustomersUseCase(getIt<AdminRepository>()),
    );
    
    getIt.registerLazySingleton<GetDeliveriesUseCase>(
      () => GetDeliveriesUseCase(getIt<AdminRepository>()),
    );
    
    getIt.registerLazySingleton<GetBillsUseCase>(
      () => GetBillsUseCase(getIt<AdminRepository>()),
    );
    
    // Customer Use Cases
    getIt.registerLazySingleton<GetCustomerDashboardUseCase>(
      () => GetCustomerDashboardUseCase(getIt<CustomerRepository>()),
    );
    
    getIt.registerLazySingleton<GetCustomerDeliveriesUseCase>(
      () => GetCustomerDeliveriesUseCase(getIt<CustomerRepository>()),
    );
    
    getIt.registerLazySingleton<GetCustomerBillsUseCase>(
      () => GetCustomerBillsUseCase(getIt<CustomerRepository>()),
    );
  }
  
  /// Initialize providers
  static void _initProviders() {
    // Auth Provider
    getIt.registerFactory<AuthProvider>(
      () => AuthProvider(
        loginUseCase: getIt<LoginUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
        getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      ),
    );
    
    // Admin Provider
    getIt.registerFactory<AdminProvider>(
      () => AdminProvider(
        getDashboardStatsUseCase: getIt<GetDashboardStatsUseCase>(),
        getCustomersUseCase: getIt<GetCustomersUseCase>(),
        getDeliveriesUseCase: getIt<GetDeliveriesUseCase>(),
        getBillsUseCase: getIt<GetBillsUseCase>(),
      ),
    );
    
    // Customer Provider
    getIt.registerFactory<CustomerProvider>(
      () => CustomerProvider(
        getCustomerDashboardUseCase: getIt<GetCustomerDashboardUseCase>(),
        getCustomerDeliveriesUseCase: getIt<GetCustomerDeliveriesUseCase>(),
        getCustomerBillsUseCase: getIt<GetCustomerBillsUseCase>(),
      ),
    );
  }
  
  /// Reset all dependencies (useful for testing)
  static Future<void> reset() async {
    await getIt.reset();
  }
}
