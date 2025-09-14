/// Customer model for dairy delivery management
class Customer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String area;
  final String city;
  final String pincode;
  final DateTime joinDate;
  final bool isActive;
  final double creditLimit;
  final double currentBalance;
  final List<String> deliveryDays; // ['monday', 'tuesday', etc.]
  final String deliveryTime; // 'morning' or 'evening'
  final Map<String, double> monthlyConsumption; // productId -> quantity

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.area,
    required this.city,
    required this.pincode,
    required this.joinDate,
    this.isActive = true,
    this.creditLimit = 5000.0,
    this.currentBalance = 0.0,
    this.deliveryDays = const ['monday', 'wednesday', 'friday'],
    this.deliveryTime = 'morning',
    this.monthlyConsumption = const {},
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
      creditLimit: (json['creditLimit'] ?? 5000.0).toDouble(),
      currentBalance: (json['currentBalance'] ?? 0.0).toDouble(),
      deliveryDays: List<String>.from(json['deliveryDays'] ?? ['monday', 'wednesday', 'friday']),
      deliveryTime: json['deliveryTime'] ?? 'morning',
      monthlyConsumption: Map<String, double>.from(json['monthlyConsumption'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'area': area,
      'city': city,
      'pincode': pincode,
      'joinDate': joinDate.toIso8601String(),
      'isActive': isActive,
      'creditLimit': creditLimit,
      'currentBalance': currentBalance,
      'deliveryDays': deliveryDays,
      'deliveryTime': deliveryTime,
      'monthlyConsumption': monthlyConsumption,
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? area,
    String? city,
    String? pincode,
    DateTime? joinDate,
    bool? isActive,
    double? creditLimit,
    double? currentBalance,
    List<String>? deliveryDays,
    String? deliveryTime,
    Map<String, double>? monthlyConsumption,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      area: area ?? this.area,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      creditLimit: creditLimit ?? this.creditLimit,
      currentBalance: currentBalance ?? this.currentBalance,
      deliveryDays: deliveryDays ?? this.deliveryDays,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      monthlyConsumption: monthlyConsumption ?? this.monthlyConsumption,
    );
  }

  String get fullAddress => '$address, $area, $city - $pincode';
  
  bool get isOverdue => currentBalance > creditLimit;
  
  double get availableCredit => creditLimit - currentBalance;
}
