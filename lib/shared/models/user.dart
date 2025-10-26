import 'package:equatable/equatable.dart';
import '../../core/errors/exceptions.dart';

/// User role enumeration
enum UserRole {
  admin('Admin'),
  manager('Manager'),
  customer('Customer');

  const UserRole(this.displayName);
  final String displayName;

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'manager':
        return UserRole.manager;
      case 'customer':
        return UserRole.customer;
      default:
        throw ValidationException(
          message: 'Invalid user role: $role',
          code: ErrorCodes.invalidFormat,
        );
    }
  }
}

/// User model representing authenticated users
class User extends Equatable {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? preferences;

  const User({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
    this.preferences,
  });

  /// Full name getter
  String get fullName => '$firstName $lastName';

  /// Display name getter
  String get displayName => fullName;

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is manager
  bool get isManager => role == UserRole.manager;

  /// Check if user is customer
  bool get isCustomer => role == UserRole.customer;

  /// Check if user can manage customers
  bool get canManageCustomers => isAdmin || isManager;

  /// Check if user can manage deliveries
  bool get canManageDeliveries => isAdmin || isManager;

  /// Check if user can manage billing
  bool get canManageBilling => isAdmin || isManager;

  /// Check if user can manage products
  bool get canManageProducts => isAdmin || isManager;

  /// Check if user can view reports
  bool get canViewReports => isAdmin || isManager;

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        firstName,
        lastName,
        role,
        isActive,
        createdAt,
        lastLoginAt,
        preferences,
      ];

  /// Create a copy of the user with updated fields
  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
    );
  }

  /// Create user from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        role: UserRole.fromString(json['role'] as String),
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastLoginAt: json['lastLoginAt'] != null
            ? DateTime.parse(json['lastLoginAt'] as String)
            : null,
        preferences: json['preferences'] as Map<String, dynamic>?,
      );
    } catch (e) {
      throw ValidationException(
        message: 'Failed to parse user from JSON: $e',
        code: ErrorCodes.validationError,
      );
    }
  }

  /// Convert user to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'preferences': preferences,
    };
  }

  /// Validate user data
  void validate() {
    if (id.isEmpty) {
      throw ValidationException(
        message: 'User ID cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (email.isEmpty || !_isValidEmail(email)) {
      throw ValidationException(
        message: 'Invalid email address',
        code: ErrorCodes.invalidFormat,
      );
    }
    if (phone.isEmpty || !_isValidPhone(phone)) {
      throw ValidationException(
        message: 'Invalid phone number',
        code: ErrorCodes.invalidFormat,
      );
    }
    if (firstName.isEmpty) {
      throw ValidationException(
        message: 'First name cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (lastName.isEmpty) {
      throw ValidationException(
        message: 'Last name cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate phone format
  bool _isValidPhone(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, fullName: $fullName, role: $role)';
  }
}

/// Authentication request model
class AuthRequest extends Equatable {
  final String emailOrPhone;
  final String password;
  final UserRole? role;

  const AuthRequest({
    required this.emailOrPhone,
    required this.password,
    this.role,
  });

  @override
  List<Object?> get props => [emailOrPhone, password, role];

  /// Validate authentication request
  void validate() {
    if (emailOrPhone.isEmpty) {
      throw ValidationException(
        message: 'Email or phone is required',
        code: ErrorCodes.requiredField,
      );
    }
    if (password.isEmpty) {
      throw ValidationException(
        message: 'Password is required',
        code: ErrorCodes.requiredField,
      );
    }
    if (password.length < 6) {
      throw ValidationException(
        message: 'Password must be at least 6 characters',
        code: ErrorCodes.invalidLength,
      );
    }
  }

  /// Create from JSON
  factory AuthRequest.fromJson(Map<String, dynamic> json) {
    return AuthRequest(
      emailOrPhone: json['emailOrPhone'] as String,
      password: json['password'] as String,
      role: json['role'] != null ? UserRole.fromString(json['role'] as String) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'emailOrPhone': emailOrPhone,
      'password': password,
      'role': role?.name,
    };
  }
}

/// Authentication response model
class AuthResponse extends Equatable {
  final User user;
  final String token;
  final DateTime expiresAt;

  const AuthResponse({
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [user, token, expiresAt];

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Create from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
