/// Billing model for monthly bills and payments
class Bill {
  final String id;
  final String customerId;
  final String customerName;
  final DateTime billDate;
  final DateTime dueDate;
  final BillStatus status;
  final List<BillItem> items;
  final double subtotal;
  final double tax;
  final double totalAmount;
  final double paidAmount;
  final double balanceAmount;
  final List<Payment> payments;
  final String notes;
  final DateTime createdAt;

  Bill({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.billDate,
    required this.dueDate,
    required this.status,
    required this.items,
    required this.subtotal,
    this.tax = 0.0,
    required this.totalAmount,
    this.paidAmount = 0.0,
    required this.balanceAmount,
    this.payments = const [],
    this.notes = '',
    required this.createdAt,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      billDate: DateTime.parse(json['billDate'] ?? DateTime.now().toIso8601String()),
      dueDate: DateTime.parse(json['dueDate'] ?? DateTime.now().toIso8601String()),
      status: BillStatus.fromString(json['status'] ?? 'pending'),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => BillItem.fromJson(item))
          .toList() ?? [],
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      tax: (json['tax'] ?? 0.0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0.0).toDouble(),
      balanceAmount: (json['balanceAmount'] ?? 0.0).toDouble(),
      payments: (json['payments'] as List<dynamic>?)
          ?.map((payment) => Payment.fromJson(payment))
          .toList() ?? [],
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'billDate': billDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'balanceAmount': balanceAmount,
      'payments': payments.map((payment) => payment.toJson()).toList(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Bill copyWith({
    String? id,
    String? customerId,
    String? customerName,
    DateTime? billDate,
    DateTime? dueDate,
    BillStatus? status,
    List<BillItem>? items,
    double? subtotal,
    double? tax,
    double? totalAmount,
    double? paidAmount,
    double? balanceAmount,
    List<Payment>? payments,
    String? notes,
    DateTime? createdAt,
  }) {
    return Bill(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      billDate: billDate ?? this.billDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      payments: payments ?? this.payments,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get statusDisplay {
    switch (status) {
      case BillStatus.pending:
        return 'Pending';
      case BillStatus.partial:
        return 'Partially Paid';
      case BillStatus.paid:
        return 'Paid';
      case BillStatus.overdue:
        return 'Overdue';
    }
  }

  bool get isOverdue => DateTime.now().isAfter(dueDate) && status != BillStatus.paid;
  bool get isPaid => status == BillStatus.paid;
  bool get isPartiallyPaid => status == BillStatus.partial;
}

/// Individual bill item
class BillItem {
  final String productId;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final DateTime deliveryDate;

  BillItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.deliveryDate,
  });

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      deliveryDate: DateTime.parse(json['deliveryDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'deliveryDate': deliveryDate.toIso8601String(),
    };
  }
}

/// Payment model
class Payment {
  final String id;
  final String billId;
  final double amount;
  final PaymentMethod method;
  final DateTime paymentDate;
  final String reference;
  final String notes;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.billId,
    required this.amount,
    required this.method,
    required this.paymentDate,
    this.reference = '',
    this.notes = '',
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? '',
      billId: json['billId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      method: PaymentMethod.fromString(json['method'] ?? 'cash'),
      paymentDate: DateTime.parse(json['paymentDate'] ?? DateTime.now().toIso8601String()),
      reference: json['reference'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billId': billId,
      'amount': amount,
      'method': method.toString().split('.').last,
      'paymentDate': paymentDate.toIso8601String(),
      'reference': reference,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get methodDisplay {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.cheque:
        return 'Cheque';
    }
  }
}

enum BillStatus {
  pending,
  partial,
  paid,
  overdue;

  static BillStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BillStatus.pending;
      case 'partial':
        return BillStatus.partial;
      case 'paid':
        return BillStatus.paid;
      case 'overdue':
        return BillStatus.overdue;
      default:
        return BillStatus.pending;
    }
  }
}

enum PaymentMethod {
  cash,
  upi,
  bankTransfer,
  cheque;

  static PaymentMethod fromString(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'upi':
        return PaymentMethod.upi;
      case 'banktransfer':
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      case 'cheque':
        return PaymentMethod.cheque;
      default:
        return PaymentMethod.cash;
    }
  }
}
