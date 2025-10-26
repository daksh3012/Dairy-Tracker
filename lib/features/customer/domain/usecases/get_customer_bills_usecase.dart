import '../../../../core/errors/result.dart';
import '../../../../shared/models/bill.dart';
import '../repositories/customer_repository.dart';

/// Use case for getting customer bills
class GetCustomerBillsUseCase {
  final CustomerRepository _repository;

  GetCustomerBillsUseCase(this._repository);

  Future<Result<List<Bill>>> call() async {
    try {
      return await _repository.getCustomerBills();
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
