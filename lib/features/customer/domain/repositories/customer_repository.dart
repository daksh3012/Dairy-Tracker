import '../../../../core/errors/result.dart';
import '../../../../shared/models/delivery.dart';
import '../../../../shared/models/bill.dart';

/// Customer repository interface
abstract class CustomerRepository {
  Future<Result<Map<String, dynamic>>> getCustomerDashboard();
  Future<Result<List<Delivery>>> getCustomerDeliveries();
  Future<Result<List<Bill>>> getCustomerBills();
}
