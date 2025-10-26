import 'package:equatable/equatable.dart';
import '../../core/errors/exceptions.dart';

/// Delivery status enumeration
enum DeliveryStatus {
  pending('Pending'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled'),
  failed('Failed');

  const DeliveryStatus(this.displayName);
  final String displayName;

  static DeliveryStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return DeliveryStatus.pending;
      case 'in_progress':
      case 'inprogress':
        return DeliveryStatus.inProgress;
      case 'completed':
        return DeliveryStatus.completed;
      case 'cancelled':
        return DeliveryStatus.cancelled;
      case 'failed':
        return DeliveryStatus.failed;
      default:
        throw ValidationException(
          message: 'Invalid delivery status: $status',
          code: ErrorCodes.invalidFormat,
        );
    }
  }
}

/// Delivery model representing dairy deliveries
class Delivery extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final DateTime deliveryDate;
  final DeliveryTimeSlot deliveryTime;
  final DeliveryStatus status;
  final List<DeliveryItem> items;
  final double totalAmount;
  final String? deliveryPerson;
  final String? notes;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final Map<String, dynamic>? metadata;

  const Delivery({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.status,
    required this.items,
    required this.totalAmount,
    this.deliveryPerson,
    this.notes,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.metadata,
  });

  /// Check if delivery is completed
  bool get isCompleted => status == DeliveryStatus.completed;

  /// Check if delivery is pending
  bool get isPending => status == DeliveryStatus.pending;

  /// Check if delivery is in progress
  bool get isInProgress => status == DeliveryStatus.inProgress;

  /// Check if delivery is cancelled
  bool get isCancelled => status == DeliveryStatus.cancelled;

  /// Check if delivery is failed
  bool get isFailed => status == DeliveryStatus.failed;

  /// Check if delivery is overdue
  bool get isOverdue {
    if (isCompleted || isCancelled) return false;
    return DateTime.now().isAfter(deliveryDate);
  }

  /// Days until delivery
  int get daysUntilDelivery {
    return deliveryDate.difference(DateTime.now()).inDays;
  }

  /// Formatted delivery date
  String get formattedDeliveryDate {
    return '${deliveryDate.day}/${deliveryDate.month}/${deliveryDate.year}';
  }

  /// Formatted delivery time
  String get formattedDeliveryTime {
    switch (deliveryTime) {
      case DeliveryTimeSlot.morning:
        return 'Morning (6:00 AM - 10:00 AM)';
      case DeliveryTimeSlot.evening:
        return 'Evening (4:00 PM - 8:00 PM)';
      case DeliveryTimeSlot.both:
        return 'Both Morning & Evening';
    }
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerName,
        customerPhone,
        deliveryAddress,
        deliveryDate,
        deliveryTime,
        status,
        items,
        totalAmount,
        deliveryPerson,
        notes,
        completedAt,
        cancelledAt,
        cancellationReason,
        metadata,
      ];

  /// Create a copy of the delivery with updated fields
  Delivery copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? deliveryAddress,
    DateTime? deliveryDate,
    DeliveryTimeSlot? deliveryTime,
    DeliveryStatus? status,
    List<DeliveryItem>? items,
    double? totalAmount,
    String? deliveryPerson,
    String? notes,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    Map<String, dynamic>? metadata,
  }) {
    return Delivery(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      status: status ?? this.status,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryPerson: deliveryPerson ?? this.deliveryPerson,
      notes: notes ?? this.notes,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create delivery from JSON
  factory Delivery.fromJson(Map<String, dynamic> json) {
    try {
      return Delivery(
        id: json['id'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        customerPhone: json['customerPhone'] as String,
        deliveryAddress: json['deliveryAddress'] as String,
        deliveryDate: DateTime.parse(json['deliveryDate'] as String),
        deliveryTime:
            DeliveryTimeSlot.fromString(json['deliveryTime'] as String),
        status: DeliveryStatus.fromString(json['status'] as String),
        items: (json['items'] as List<dynamic>)
            .map((item) => DeliveryItem.fromJson(item as Map<String, dynamic>))
            .toList(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        deliveryPerson: json['deliveryPerson'] as String?,
        notes: json['notes'] as String?,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        cancelledAt: json['cancelledAt'] != null
            ? DateTime.parse(json['cancelledAt'] as String)
            : null,
        cancellationReason: json['cancellationReason'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
    } catch (e) {
      throw ValidationException(
        message: 'Failed to parse delivery from JSON: $e',
        code: ErrorCodes.validationError,
      );
    }
  }

  /// Convert delivery to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'deliveryDate': deliveryDate.toIso8601String(),
      'deliveryTime': deliveryTime.name,
      'status': status.name,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'deliveryPerson': deliveryPerson,
      'notes': notes,
      'completedAt': completedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'metadata': metadata,
    };
  }

  /// Validate delivery data
  void validate() {
    if (id.isEmpty) {
      throw ValidationException(
        message: 'Delivery ID cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (customerId.isEmpty) {
      throw ValidationException(
        message: 'Customer ID cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (customerName.isEmpty) {
      throw ValidationException(
        message: 'Customer name cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (deliveryAddress.isEmpty) {
      throw ValidationException(
        message: 'Delivery address cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (items.isEmpty) {
      throw ValidationException(
        message: 'Delivery must have at least one item',
        code: ErrorCodes.requiredField,
      );
    }
    if (totalAmount < 0) {
      throw ValidationException(
        message: 'Total amount cannot be negative',
        code: ErrorCodes.invalidRange,
      );
    }
  }

  @override
  String toString() {
    return 'Delivery(id: $id, customer: $customerName, date: $formattedDeliveryDate, status: $status)';
  }
}

/// Delivery item model
class DeliveryItem extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String productUnit;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final String? notes;

  const DeliveryItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productUnit,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        productUnit,
        quantity,
        unitPrice,
        totalPrice,
        notes,
      ];

  /// Create a copy of the delivery item with updated fields
  DeliveryItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productUnit,
    double? quantity,
    double? unitPrice,
    double? totalPrice,
    String? notes,
  }) {
    return DeliveryItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productUnit: productUnit ?? this.productUnit,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
    );
  }

  /// Create delivery item from JSON
  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productUnit: json['productUnit'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

  /// Convert delivery item to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productUnit': productUnit,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'DeliveryItem(product: $productName, quantity: $quantity $productUnit, total: ₹$totalPrice)';
  }
}

/// Delivery time slot enumeration
enum DeliveryTimeSlot {
  morning('Morning'),
  evening('Evening'),
  both('Both');

  const DeliveryTimeSlot(this.displayName);
  final String displayName;

  static DeliveryTimeSlot fromString(String time) {
    switch (time.toLowerCase()) {
      case 'morning':
        return DeliveryTimeSlot.morning;
      case 'evening':
        return DeliveryTimeSlot.evening;
      case 'both':
        return DeliveryTimeSlot.both;
      default:
        throw ValidationException(
          message: 'Invalid delivery time: $time',
          code: ErrorCodes.invalidFormat,
        );
    }
  }
}
