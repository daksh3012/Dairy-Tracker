import '../../../../core/errors/result.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../../shared/services/mock_data_service.dart';
import '../../../../shared/models/customer.dart';
import '../../../../shared/models/delivery.dart';
import '../../../../shared/models/bill.dart';
import '../../../../shared/models/product.dart';

/// Admin repository implementation
class AdminRepositoryImpl implements AdminRepository {
  final MockDataService _mockDataService;

  AdminRepositoryImpl({
    required MockDataService mockDataService,
  }) : _mockDataService = mockDataService;

  @override
  Future<Result<Map<String, dynamic>>> getDashboardStats() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Get dashboard stats from mock data
      final stats = MockDataService.getDashboardStats();

      return Result.success(stats);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Customer>>> getCustomers() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get customers from mock data
      final customers = MockDataService.customers;

      return Result.success(customers);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Delivery>>> getDeliveries() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get deliveries from mock data
      final deliveries = MockDataService.deliveries;

      return Result.success(deliveries);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Bill>>> getBills() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get bills from mock data
      final bills = MockDataService.bills;

      return Result.success(bills);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Product>>> getProducts() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get products from mock data
      final products = MockDataService.products;

      return Result.success(products);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
