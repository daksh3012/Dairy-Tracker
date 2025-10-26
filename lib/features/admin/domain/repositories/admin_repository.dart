import '../../../../core/errors/result.dart';
import '../../../../shared/models/customer.dart';
import '../../../../shared/models/delivery.dart';
import '../../../../shared/models/bill.dart';
import '../../../../shared/models/product.dart';

/// Admin repository interface
abstract class AdminRepository {
  Future<Result<Map<String, dynamic>>> getDashboardStats();
  Future<Result<List<Customer>>> getCustomers();
  Future<Result<List<Delivery>>> getDeliveries();
  Future<Result<List<Bill>>> getBills();
  Future<Result<List<Product>>> getProducts();
}
