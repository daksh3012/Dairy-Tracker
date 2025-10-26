import '../../../../core/errors/result.dart';
import '../../../../shared/models/customer.dart';
import '../repositories/admin_repository.dart';

/// Use case for getting all customers
class GetCustomersUseCase {
  final AdminRepository _repository;

  GetCustomersUseCase(this._repository);

  Future<Result<List<Customer>>> call() async {
    try {
      return await _repository.getCustomers();
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
