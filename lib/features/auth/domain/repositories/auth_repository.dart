import '../../../../core/errors/result.dart';
import '../../../../shared/models/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  Future<Result<User>> login(String emailOrPhone, String password, UserRole role);
  Future<Result<void>> logout();
  Future<Result<User?>> getCurrentUser();
}
