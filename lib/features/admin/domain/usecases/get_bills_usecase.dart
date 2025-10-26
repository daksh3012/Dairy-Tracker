import '../../../../core/errors/result.dart';
import '../../../../shared/models/bill.dart';
import '../repositories/admin_repository.dart';

/// Use case for getting all bills
class GetBillsUseCase {
  final AdminRepository _repository;

  GetBillsUseCase(this._repository);

  Future<Result<List<Bill>>> call() async {
    try {
      return await _repository.getBills();
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
