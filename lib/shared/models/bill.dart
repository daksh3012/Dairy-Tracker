import 'package:equatable/equatable.dart';
import '../../core/errors/exceptions.dart';

/// Bill status enumeration
enum BillStatus {
  draft('Draft'),
  pending('Pending'),
  paid('Paid'),
  overdue('Overdue'),
  cancelled('Cancelled');

  const BillStatus(this.displayName);
  final String displayName;

  static BillStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return BillStatus.draft;
      case 'pending':
        return BillStatus.pending;
      case 'paid':
        return BillStatus.paid;
      case 'overdue':
        return BillStatus.overdue;
      case 'cancelled':
        return BillStatus.cancelled;
      default:
        throw ValidationException(
          message: 'Invalid bill status: $status',
          code: ErrorCodes.invalidFormat,
        );
    }
  }
}

/// Payment method enumeration
enum PaymentMethod {
  cash('Cash'),
  upi('UPI'),
  bankTransfer('Bank Transfer'),
  cheque('Cheque'),
  card('Card'),
  wallet('Wallet');

  const PaymentMethod(this.displayName);
  final String displayName;

  static PaymentMethod fromString(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'upi':
        return PaymentMethod.upi;
      case 'bank_transfer':
      case 'banktransfer':
        return PaymentMethod.bankTransfer;
      case 'cheque':
        return PaymentMethod.cheque;
      case 'card':
        return PaymentMethod.card;
      case 'wallet':
        return PaymentMethod.wallet;
      default:
        throw ValidationException(
          message: 'Invalid payment method: $method',
          code: ErrorCodes.invalidFormat,
        );
    }
  }
}

/// Bill model representing customer bills
class Bill extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String billNumber;
  final DateTime billDate;
  final DateTime dueDate;
  final BillStatus status;
  final List<BillItem> items;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final double paidAmount;
  final double balanceAmount;
  final String? notes;
  final List<Payment> payments;
  final DateTime? paidAt;
  final Map<String, dynamic>? metadata;

  const Bill({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.billNumber,
    required this.billDate,
    required this.dueDate,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.balanceAmount,
    this.notes,
    this.payments = const [],
    this.paidAt,
    this.metadata,
  });

  /// Check if bill is paid
  bool get isPaid => status == BillStatus.paid;

  /// Check if bill is pending
  bool get isPending => status == BillStatus.pending;

  /// Check if bill is overdue
  bool get isOverdue => status == BillStatus.overdue;

  /// Check if bill is draft
  bool get isDraft => status == BillStatus.draft;

  /// Check if bill is cancelled
  bool get isCancelled => status == BillStatus.cancelled;

  /// Check if bill is fully paid
  bool get isFullyPaid => balanceAmount <= 0;

  /// Check if bill is partially paid
  bool get isPartiallyPaid => paidAmount > 0 && balanceAmount > 0;

  /// Days until due date
  int get daysUntilDue {
    return dueDate.difference(DateTime.now()).inDays;
  }

  /// Days overdue
  int get daysOverdue {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }

  /// Formatted bill date
  String get formattedBillDate {
    return '${billDate.day}/${billDate.month}/${billDate.year}';
  }

  /// Formatted due date
  String get formattedDueDate {
    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  /// Payment percentage
  double get paymentPercentage {
    if (totalAmount == 0) return 0;
    return (paidAmount / totalAmount) * 100;
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerName,
        customerPhone,
        customerAddress,
        billNumber,
        billDate,
        dueDate,
        status,
        items,
        subtotal,
        taxAmount,
        discountAmount,
        totalAmount,
        paidAmount,
        balanceAmount,
        notes,
        payments,
        paidAt,
        metadata,
      ];

  /// Create a copy of the bill with updated fields
  Bill copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? billNumber,
    DateTime? billDate,
    DateTime? dueDate,
    BillStatus? status,
    List<BillItem>? items,
    double? subtotal,
    double? taxAmount,
    double? discountAmount,
    double? totalAmount,
    double? paidAmount,
    double? balanceAmount,
    String? notes,
    List<Payment>? payments,
    DateTime? paidAt,
    Map<String, dynamic>? metadata,
  }) {
    return Bill(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      billNumber: billNumber ?? this.billNumber,
      billDate: billDate ?? this.billDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      notes: notes ?? this.notes,
      payments: payments ?? this.payments,
      paidAt: paidAt ?? this.paidAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create bill from JSON
  factory Bill.fromJson(Map<String, dynamic> json) {
    try {
      return Bill(
        id: json['id'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        customerPhone: json['customerPhone'] as String,
        customerAddress: json['customerAddress'] as String,
        billNumber: json['billNumber'] as String,
        billDate: DateTime.parse(json['billDate'] as String),
        dueDate: DateTime.parse(json['dueDate'] as String),
        status: BillStatus.fromString(json['status'] as String),
        items: (json['items'] as List<dynamic>)
            .map((item) => BillItem.fromJson(item as Map<String, dynamic>))
            .toList(),
        subtotal: (json['subtotal'] as num).toDouble(),
        taxAmount: (json['taxAmount'] as num).toDouble(),
        discountAmount: (json['discountAmount'] as num).toDouble(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        paidAmount: (json['paidAmount'] as num).toDouble(),
        balanceAmount: (json['balanceAmount'] as num).toDouble(),
        notes: json['notes'] as String?,
        payments: (json['payments'] as List<dynamic>?)
                ?.map((payment) => Payment.fromJson(payment as Map<String, dynamic>))
                .toList() ??
            [],
        paidAt: json['paidAt'] != null
            ? DateTime.parse(json['paidAt'] as String)
            : null,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
    } catch (e) {
      throw ValidationException(
        message: 'Failed to parse bill from JSON: $e',
        code: ErrorCodes.validationError,
      );
    }
  }

  /// Convert bill to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'billNumber': billNumber,
      'billDate': billDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status.name,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'balanceAmount': balanceAmount,
      'notes': notes,
      'payments': payments.map((payment) => payment.toJson()).toList(),
      'paidAt': paidAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Validate bill data
  void validate() {
    if (id.isEmpty) {
      throw ValidationException(
        message: 'Bill ID cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (customerId.isEmpty) {
      throw ValidationException(
        message: 'Customer ID cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (billNumber.isEmpty) {
      throw ValidationException(
        message: 'Bill number cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (items.isEmpty) {
      throw ValidationException(
        message: 'Bill must have at least one item',
        code: ErrorCodes.requiredField,
      );
    }
    if (totalAmount < 0) {
      throw ValidationException(
        message: 'Total amount cannot be negative',
        code: ErrorCodes.invalidRange,
      );
    }
    if (paidAmount < 0) {
      throw ValidationException(
        message: 'Paid amount cannot be negative',
        code: ErrorCodes.invalidRange,
      );
    }
    if (balanceAmount < 0) {
      throw ValidationException(
        message: 'Balance amount cannot be negative',
        code: ErrorCodes.invalidRange,
      );
    }
  }

  @override
  String toString() {
    return 'Bill(id: $id, customer: $customerName, amount: ₹$totalAmount, status: $status)';
  }
}

/// Bill item model
class BillItem extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String productUnit;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final String? description;

  const BillItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productUnit,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.description,
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
        description,
      ];

  /// Create a copy of the bill item with updated fields
  BillItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productUnit,
    double? quantity,
    double? unitPrice,
    double? totalPrice,
    String? description,
  }) {
    return BillItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productUnit: productUnit ?? this.productUnit,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      description: description ?? this.description,
    );
  }

  /// Create bill item from JSON
  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productUnit: json['productUnit'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }

  /// Convert bill item to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productUnit': productUnit,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'BillItem(product: $productName, quantity: $quantity $productUnit, total: ₹$totalPrice)';
  }
}

/// Payment model
class Payment extends Equatable {
  final String id;
  final String billId;
  final double amount;
  final PaymentMethod method;
  final DateTime paymentDate;
  final String? reference;
  final String? notes;
  final String? transactionId;

  const Payment({
    required this.id,
    required this.billId,
    required this.amount,
    required this.method,
    required this.paymentDate,
    this.reference,
    this.notes,
    this.transactionId,
  });

  @override
  List<Object?> get props => [
        id,
        billId,
        amount,
        method,
        paymentDate,
        reference,
        notes,
        transactionId,
      ];

  /// Create a copy of the payment with updated fields
  Payment copyWith({
    String? id,
    String? billId,
    double? amount,
    PaymentMethod? method,
    DateTime? paymentDate,
    String? reference,
    String? notes,
    String? transactionId,
  }) {
    return Payment(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      paymentDate: paymentDate ?? this.paymentDate,
      reference: reference ?? this.reference,
      notes: notes ?? this.notes,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  /// Create payment from JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      billId: json['billId'] as String,
      amount: (json['amount'] as num).toDouble(),
      method: PaymentMethod.fromString(json['method'] as String),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      reference: json['reference'] as String?,
      notes: json['notes'] as String?,
      transactionId: json['transactionId'] as String?,
    );
  }

  /// Convert payment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billId': billId,
      'amount': amount,
      'method': method.name,
      'paymentDate': paymentDate.toIso8601String(),
      'reference': reference,
      'notes': notes,
      'transactionId': transactionId,
    };
  }

  @override
  String toString() {
    return 'Payment(id: $id, amount: ₹$amount, method: ${method.displayName})';
  }
}
