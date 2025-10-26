import 'package:flutter/foundation.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/models/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';

/// Authentication provider for managing user login/logout state
class AuthProvider with ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin == true;
  bool get isManager => _currentUser?.isManager == true;
  bool get isCustomer => _currentUser?.isCustomer == true;

  /// Initialize authentication state
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _getCurrentUserUseCase();
      result.fold(
        (user) {
          _currentUser = user;
          _isLoading = false;
          notifyListeners();
        },
        (exception) {
          _currentUser = null;
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with email/phone and password
  Future<bool> login(
      String emailOrPhone, String password, UserRole role) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _loginUseCase(
        LoginParams(
          emailOrPhone: emailOrPhone,
          password: password,
          role: role,
        ),
      );

      return result.fold(
        (user) {
          _currentUser = user;
          _isLoading = false;
          notifyListeners();
          return true;
        },
        (exception) {
          _errorMessage = exception.toString();
          _isLoading = false;
          notifyListeners();
          return false;
        },
      );
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _logoutUseCase();
      _currentUser = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Update current user profile
  void updateProfile(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}
