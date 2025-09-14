/// User model for authentication and role management
class User {
  final String id;
  final String email;
  final String phone;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    required this.role,
    required this.createdAt,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'user'),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    UserRole? role,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum UserRole {
  admin,
  user;

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'user':
        return UserRole.user;
      default:
        return UserRole.user;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.user:
        return 'Customer';
    }
  }
}
