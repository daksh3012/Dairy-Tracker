import '../../../../core/errors/result.dart';
import '../../domain/repositories/admin_repository.dart';

/// Get dashboard stats use case
class GetDashboardStatsUseCase {
  final AdminRepository _repository;

  GetDashboardStatsUseCase(this._repository);

  Future<Result<Map<String, dynamic>>> call() async {
    try {
      return await _repository.getDashboardStats();
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
