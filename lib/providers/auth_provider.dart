import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../utils/mock_data.dart';

/// Authentication provider for managing user login/logout state
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get isCustomer => _currentUser?.role == UserRole.user;

  /// Login with email/phone and password
  Future<bool> login(String emailOrPhone, String password, UserRole role) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock authentication logic
      final mockUsers = MockDataService.generateMockUsers();
      
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
        _currentUser = foundUser;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid credentials or role mismatch';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign up new user
  Future<bool> signUp(String name, String email, String phone, String password, UserRole role) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock signup logic - create new user
      final newUser = User(
        id: 'USER_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        phone: phone,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Signup failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout current user
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
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
