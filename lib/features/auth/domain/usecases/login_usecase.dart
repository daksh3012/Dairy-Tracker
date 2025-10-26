import '../../../../core/errors/result.dart';
import '../../../../shared/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Login use case
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<User>> call(LoginParams params) async {
    try {
      return await _repository.login(
        params.emailOrPhone,
        params.password,
        params.role,
      );
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}

/// Login parameters
class LoginParams {
  final String emailOrPhone;
  final String password;
  final UserRole role;

  const LoginParams({
    required this.emailOrPhone,
    required this.password,
    required this.role,
  });
}
