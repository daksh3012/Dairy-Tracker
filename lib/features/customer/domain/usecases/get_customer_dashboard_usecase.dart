import '../../../../core/errors/result.dart';
import '../../domain/repositories/customer_repository.dart';

/// Get customer dashboard use case
class GetCustomerDashboardUseCase {
  final CustomerRepository _repository;

  GetCustomerDashboardUseCase(this._repository);

  Future<Result<Map<String, dynamic>>> call() async {
    try {
      return await _repository.getCustomerDashboard();
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
