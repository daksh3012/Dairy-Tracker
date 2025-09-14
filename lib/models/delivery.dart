/// Delivery model for tracking daily deliveries
class Delivery {
  final String id;
  final String customerId;
  final String customerName;
  final DateTime deliveryDate;
  final DeliveryStatus status;
  final List<DeliveryItem> items;
  final double totalAmount;
  final String deliveryPerson;
  final String notes;
  final DateTime createdAt;
  final DateTime? completedAt;

  Delivery({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.deliveryDate,
    required this.status,
    required this.items,
    required this.totalAmount,
    this.deliveryPerson = '',
    this.notes = '',
    required this.createdAt,
    this.completedAt,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      deliveryDate: DateTime.parse(json['deliveryDate'] ?? DateTime.now().toIso8601String()),
      status: DeliveryStatus.fromString(json['status'] ?? 'pending'),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => DeliveryItem.fromJson(item))
          .toList() ?? [],
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      deliveryPerson: json['deliveryPerson'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'deliveryDate': deliveryDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'deliveryPerson': deliveryPerson,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Delivery copyWith({
    String? id,
    String? customerId,
    String? customerName,
    DateTime? deliveryDate,
    DeliveryStatus? status,
    List<DeliveryItem>? items,
    double? totalAmount,
    String? deliveryPerson,
    String? notes,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Delivery(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryPerson: deliveryPerson ?? this.deliveryPerson,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  String get statusDisplay {
    switch (status) {
      case DeliveryStatus.pending:
        return 'Pending';
      case DeliveryStatus.inProgress:
        return 'In Progress';
      case DeliveryStatus.completed:
        return 'Completed';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isCompleted => status == DeliveryStatus.completed;
  bool get isPending => status == DeliveryStatus.pending;
}

/// Individual delivery item within a delivery
class DeliveryItem {
  final String productId;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double totalPrice;

  DeliveryItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }
}

enum DeliveryStatus {
  pending,
  inProgress,
  completed,
  cancelled;

  static DeliveryStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return DeliveryStatus.pending;
      case 'inprogress':
      case 'in_progress':
        return DeliveryStatus.inProgress;
      case 'completed':
        return DeliveryStatus.completed;
      case 'cancelled':
        return DeliveryStatus.cancelled;
      default:
        return DeliveryStatus.pending;
    }
  }
}
