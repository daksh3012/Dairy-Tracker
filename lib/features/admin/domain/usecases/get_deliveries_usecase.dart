import '../../../../core/errors/result.dart';
import '../../../../shared/models/delivery.dart';
import '../repositories/admin_repository.dart';

/// Use case for getting all deliveries
class GetDeliveriesUseCase {
  final AdminRepository _repository;

  GetDeliveriesUseCase(this._repository);

  Future<Result<List<Delivery>>> call() async {
    try {
      return await _repository.getDeliveries();
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
