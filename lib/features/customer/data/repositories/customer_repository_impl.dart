import '../../../../core/errors/result.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../../../shared/services/mock_data_service.dart';
import '../../../../shared/models/delivery.dart';
import '../../../../shared/models/bill.dart';

/// Customer repository implementation
class CustomerRepositoryImpl implements CustomerRepository {
  final MockDataService _mockDataService;

  CustomerRepositoryImpl({
    required MockDataService mockDataService,
  }) : _mockDataService = mockDataService;

  @override
  Future<Result<Map<String, dynamic>>> getCustomerDashboard() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Get customer dashboard data from mock service
      // Using customer_001 as default for demo
      final dashboardData = MockDataService.getCustomerDashboardData('cust_001');

      return Result.success(dashboardData);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Delivery>>> getCustomerDeliveries() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get customer deliveries from mock data
      // Filter deliveries for customer_001
      final allDeliveries = MockDataService.deliveries;
      final customerDeliveries = allDeliveries.where((d) => d.customerId == 'cust_001').toList();

      return Result.success(customerDeliveries);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Bill>>> getCustomerBills() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get customer bills from mock data
      // Filter bills for customer_001
      final allBills = MockDataService.bills;
      final customerBills = allBills.where((b) => b.customerId == 'cust_001').toList();

      return Result.success(customerBills);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
