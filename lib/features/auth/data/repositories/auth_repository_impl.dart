import '../../../../core/errors/result.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../shared/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../shared/services/mock_data_service.dart';
import '../../../../shared/services/local_storage_service.dart';

/// Authentication repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final MockDataService _mockDataService;
  final LocalStorageService _localStorageService;

  AuthRepositoryImpl({
    required MockDataService mockDataService,
    required LocalStorageService localStorageService,
  })  : _mockDataService = mockDataService,
        _localStorageService = localStorageService;

  @override
  Future<Result<User>> login(
      String emailOrPhone, String password, UserRole role) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Get mock users
      final mockUsers = _mockDataService.generateMockUsers();

      // Find user by email or phone
      User? foundUser;
      for (final user in mockUsers) {
        if ((user.email == emailOrPhone || user.phone == emailOrPhone) &&
            user.role == role) {
          foundUser = user;
          break;
        }
      }

      if (foundUser != null) {
        // Save user data to local storage
        await _localStorageService.saveUserData(foundUser.toJson());
        await _localStorageService.saveUserToken('mock_token_${foundUser.id}');

        return Result.success(foundUser);
      } else {
        return Result.failure(AuthException(
          message: 'Invalid credentials or role mismatch',
          code: ErrorCodes.invalidCredentials,
        ));
      }
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Clear local storage
      await _localStorageService.logout();
      return Result.success(null);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      // Check if user is logged in
      if (!_localStorageService.isLoggedIn) {
        return Result.success(null);
      }

      // Get user data from local storage
      final userData = _localStorageService.getUserData();
      if (userData != null) {
        final user = User.fromJson(userData);
        return Result.success(user);
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
