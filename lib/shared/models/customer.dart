import 'package:equatable/equatable.dart';
import '../../core/errors/exceptions.dart';
import 'delivery.dart';

/// Customer model representing dairy delivery customers
class Customer extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String area;
  final String city;
  final String state;
  final String zipCode;
  final DateTime joinDate;
  final bool isActive;
  final double creditLimit;
  final double currentBalance;
  final List<DeliveryDay> deliveryDays;
  final DeliveryTimeSlot deliveryTime;
  final Map<String, double> monthlyConsumption;
  final DateTime? lastDeliveryDate;
  final DateTime? lastPaymentDate;
  final Map<String, dynamic>? preferences;

  const Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.area,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.joinDate,
    this.isActive = true,
    this.creditLimit = 5000.0,
    this.currentBalance = 0.0,
    this.deliveryDays = const [
      DeliveryDay.monday,
      DeliveryDay.wednesday,
      DeliveryDay.friday
    ],
    this.deliveryTime = DeliveryTimeSlot.morning,
    this.monthlyConsumption = const {},
    this.lastDeliveryDate,
    this.lastPaymentDate,
    this.preferences,
  });

  /// Full name getter
  String get fullName => '$firstName $lastName';

  /// Display name getter
  String get displayName => fullName;

  /// Full address getter
  String get fullAddress => '$address, $area, $city, $state - $zipCode';

  /// Available credit getter
  double get availableCredit => creditLimit - currentBalance;

  /// Check if customer is overdue
  bool get isOverdue => currentBalance > creditLimit;

  /// Check if customer has low credit
  bool get hasLowCredit => availableCredit < 1000.0;

  /// Customer status getter
  CustomerStatus get status {
    if (!isActive) return CustomerStatus.inactive;
    if (isOverdue) return CustomerStatus.overdue;
    if (hasLowCredit) return CustomerStatus.lowCredit;
    return CustomerStatus.active;
  }

  /// Days since last delivery
  int? get daysSinceLastDelivery {
    if (lastDeliveryDate == null) return null;
    return DateTime.now().difference(lastDeliveryDate!).inDays;
  }

  /// Days since last payment
  int? get daysSinceLastPayment {
    if (lastPaymentDate == null) return null;
    return DateTime.now().difference(lastPaymentDate!).inDays;
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        area,
        city,
        state,
        zipCode,
        joinDate,
        isActive,
        creditLimit,
        currentBalance,
        deliveryDays,
        deliveryTime,
        monthlyConsumption,
        lastDeliveryDate,
        lastPaymentDate,
        preferences,
      ];

  /// Create a copy of the customer with updated fields
  Customer copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? area,
    String? city,
    String? state,
    String? zipCode,
    DateTime? joinDate,
    bool? isActive,
    double? creditLimit,
    double? currentBalance,
    List<DeliveryDay>? deliveryDays,
    DeliveryTimeSlot? deliveryTime,
    Map<String, double>? monthlyConsumption,
    DateTime? lastDeliveryDate,
    DateTime? lastPaymentDate,
    Map<String, dynamic>? preferences,
  }) {
    return Customer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      area: area ?? this.area,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      creditLimit: creditLimit ?? this.creditLimit,
      currentBalance: currentBalance ?? this.currentBalance,
      deliveryDays: deliveryDays ?? this.deliveryDays,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      monthlyConsumption: monthlyConsumption ?? this.monthlyConsumption,
      lastDeliveryDate: lastDeliveryDate ?? this.lastDeliveryDate,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      preferences: preferences ?? this.preferences,
    );
  }

  /// Create customer from JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    try {
      return Customer(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        address: json['address'] as String,
        area: json['area'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        zipCode: json['zipCode'] as String,
        joinDate: DateTime.parse(json['joinDate'] as String),
        isActive: json['isActive'] as bool? ?? true,
        creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 5000.0,
        currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0.0,
        deliveryDays: (json['deliveryDays'] as List<dynamic>?)
                ?.map((day) => DeliveryDay.fromString(day as String))
                .toList() ??
            [DeliveryDay.monday, DeliveryDay.wednesday, DeliveryDay.friday],
        deliveryTime: DeliveryTimeSlot.fromString(
            json['deliveryTime'] as String? ?? 'morning'),
        monthlyConsumption: Map<String, double>.from(
          json['monthlyConsumption'] as Map<String, dynamic>? ?? {},
        ),
        lastDeliveryDate: json['lastDeliveryDate'] != null
            ? DateTime.parse(json['lastDeliveryDate'] as String)
            : null,
        lastPaymentDate: json['lastPaymentDate'] != null
            ? DateTime.parse(json['lastPaymentDate'] as String)
            : null,
        preferences: json['preferences'] as Map<String, dynamic>?,
      );
    } catch (e) {
      throw ValidationException(
        message: 'Failed to parse customer from JSON: $e',
        code: ErrorCodes.validationError,
      );
    }
  }

  /// Convert customer to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'area': area,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'joinDate': joinDate.toIso8601String(),
      'isActive': isActive,
      'creditLimit': creditLimit,
      'currentBalance': currentBalance,
      'deliveryDays': deliveryDays.map((day) => day.name).toList(),
      'deliveryTime': deliveryTime.name,
      'monthlyConsumption': monthlyConsumption,
      'lastDeliveryDate': lastDeliveryDate?.toIso8601String(),
      'lastPaymentDate': lastPaymentDate?.toIso8601String(),
      'preferences': preferences,
    };
  }

  /// Validate customer data
  void validate() {
    if (id.isEmpty) {
      throw ValidationException(
        message: 'Customer ID cannot be empty',
        code: ErrorCodes.requiredField,
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
    if (address.isEmpty) {
      throw ValidationException(
        message: 'Address cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (area.isEmpty) {
      throw ValidationException(
        message: 'Area cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (city.isEmpty) {
      throw ValidationException(
        message: 'City cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (state.isEmpty) {
      throw ValidationException(
        message: 'State cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (zipCode.isEmpty) {
      throw ValidationException(
        message: 'ZIP code cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (creditLimit < 0) {
      throw ValidationException(
        message: 'Credit limit cannot be negative',
        code: ErrorCodes.invalidRange,
      );
    }
    if (currentBalance < 0) {
      throw ValidationException(
        message: 'Current balance cannot be negative',
        code: ErrorCodes.invalidRange,
      );
    }
    if (deliveryDays.isEmpty) {
      throw ValidationException(
        message: 'At least one delivery day must be selected',
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
    return 'Customer(id: $id, name: $fullName, email: $email, status: $status)';
  }
}

/// Delivery day enumeration
enum DeliveryDay {
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday'),
  sunday('Sunday');

  const DeliveryDay(this.displayName);
  final String displayName;

  static DeliveryDay fromString(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DeliveryDay.monday;
      case 'tuesday':
        return DeliveryDay.tuesday;
      case 'wednesday':
        return DeliveryDay.wednesday;
      case 'thursday':
        return DeliveryDay.thursday;
      case 'friday':
        return DeliveryDay.friday;
      case 'saturday':
        return DeliveryDay.saturday;
      case 'sunday':
        return DeliveryDay.sunday;
      default:
        throw ValidationException(
          message: 'Invalid delivery day: $day',
          code: ErrorCodes.invalidFormat,
        );
    }
  }
}

/// Customer status enumeration
enum CustomerStatus {
  active('Active'),
  inactive('Inactive'),
  overdue('Overdue'),
  lowCredit('Low Credit');

  const CustomerStatus(this.displayName);
  final String displayName;
}
