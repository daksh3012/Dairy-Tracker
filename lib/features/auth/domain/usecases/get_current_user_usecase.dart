import '../../../../core/errors/result.dart';
import '../../../../shared/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Get current user use case
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Result<User?>> call() async {
    try {
      return await _repository.getCurrentUser();
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
