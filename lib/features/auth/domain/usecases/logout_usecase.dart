import '../../../../core/errors/result.dart';
import '../../domain/repositories/auth_repository.dart';

/// Logout use case
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Result<void>> call() async {
    try {
      return await _repository.logout();
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
