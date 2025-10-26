import '../../../../core/errors/result.dart';
import '../../../../shared/models/delivery.dart';
import '../repositories/customer_repository.dart';

/// Use case for getting customer deliveries
class GetCustomerDeliveriesUseCase {
  final CustomerRepository _repository;

  GetCustomerDeliveriesUseCase(this._repository);

  Future<Result<List<Delivery>>> call() async {
    try {
      return await _repository.getCustomerDeliveries();
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
