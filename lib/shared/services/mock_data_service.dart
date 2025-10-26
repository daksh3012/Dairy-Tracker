import '../models/user.dart';
import '../models/customer.dart';
import '../models/delivery.dart';
import '../models/bill.dart';
import '../models/product.dart';

/// Mock data service providing realistic test data
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock Users
  static final List<User> _mockUsers = [
    User(
      id: 'admin_001',
        email: 'admin@dairytrack.com',
      phone: '+91-9876543210',
      firstName: 'Rajesh',
      lastName: 'Kumar',
        role: UserRole.admin,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    User(
      id: 'customer_001',
      email: 'john.doe@email.com',
      phone: '+91-9876543211',
      firstName: 'John',
      lastName: 'Doe',
      role: UserRole.customer,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    User(
      id: 'customer_002',
      email: 'sarah.smith@email.com',
      phone: '+91-9876543212',
      firstName: 'Sarah',
      lastName: 'Smith',
        role: UserRole.customer,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      lastLoginAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  // Mock Products
  static final List<Product> _mockProducts = [
    Product(
      id: 'prod_001',
      name: 'Fresh Cow Milk',
      description: 'Pure, fresh cow milk delivered daily',
      category: ProductCategory.milk,
      unit: ProductUnit.liter,
      price: 60.0,
      stock: 500.0,
      minStock: 50.0,
      status: ProductStatus.available,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    Product(
      id: 'prod_002',
      name: 'Buffalo Milk',
      description: 'Rich and creamy buffalo milk',
      category: ProductCategory.milk,
      unit: ProductUnit.liter,
      price: 80.0,
      stock: 300.0,
      minStock: 30.0,
      status: ProductStatus.available,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
    ),
    Product(
      id: 'prod_003',
      name: 'Fresh Curd',
      description: 'Homemade fresh curd',
      category: ProductCategory.curd,
      unit: ProductUnit.kilogram,
      price: 120.0,
      stock: 100.0,
      minStock: 20.0,
      status: ProductStatus.available,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
    Product(
      id: 'prod_004',
      name: 'Butter',
      description: 'Pure white butter',
      category: ProductCategory.butter,
      unit: ProductUnit.kilogram,
      price: 400.0,
      stock: 50.0,
      minStock: 10.0,
      status: ProductStatus.available,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
    ),
    Product(
      id: 'prod_005',
      name: 'Paneer',
      description: 'Fresh cottage cheese',
      category: ProductCategory.paneer,
      unit: ProductUnit.kilogram,
      price: 300.0,
      stock: 25.0,
      minStock: 5.0,
      status: ProductStatus.lowStock,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    Product(
      id: 'prod_006',
      name: 'Ghee',
      description: 'Pure clarified butter',
      category: ProductCategory.ghee,
      unit: ProductUnit.kilogram,
      price: 600.0,
      stock: 0.0,
      minStock: 5.0,
      status: ProductStatus.outOfStock,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
    ),
  ];

  // Mock Customers
  static final List<Customer> _mockCustomers = [
    Customer(
      id: 'cust_001',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@email.com',
      phone: '+91-9876543211',
      address: '123 Main Street',
      area: 'Downtown',
      city: 'Mumbai',
      state: 'Maharashtra',
      zipCode: '400001',
      joinDate: DateTime.now().subtract(const Duration(days: 180)),
      isActive: true,
      creditLimit: 5000.0,
      currentBalance: 2450.0,
      deliveryDays: [DeliveryDay.monday, DeliveryDay.wednesday, DeliveryDay.friday],
      deliveryTime: DeliveryTimeSlot.morning,
      lastDeliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      lastPaymentDate: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Customer(
      id: 'cust_002',
      firstName: 'Sarah',
      lastName: 'Smith',
      email: 'sarah.smith@email.com',
      phone: '+91-9876543212',
      address: '456 Oak Avenue',
      area: 'Suburbs',
      city: 'Mumbai',
      state: 'Maharashtra',
      zipCode: '400002',
      joinDate: DateTime.now().subtract(const Duration(days: 120)),
      isActive: true,
      creditLimit: 3000.0,
      currentBalance: 1200.0,
      deliveryDays: [DeliveryDay.tuesday, DeliveryDay.thursday, DeliveryDay.saturday],
      deliveryTime: DeliveryTimeSlot.evening,
      lastDeliveryDate: DateTime.now().subtract(const Duration(days: 2)),
      lastPaymentDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Customer(
      id: 'cust_003',
      firstName: 'Mike',
      lastName: 'Johnson',
      email: 'mike.johnson@email.com',
      phone: '+91-9876543213',
      address: '789 Pine Road',
      area: 'Industrial',
      city: 'Mumbai',
      state: 'Maharashtra',
      zipCode: '400003',
      joinDate: DateTime.now().subtract(const Duration(days: 90)),
      isActive: true,
      creditLimit: 10000.0,
      currentBalance: 7500.0,
      deliveryDays: [DeliveryDay.monday, DeliveryDay.tuesday, DeliveryDay.wednesday, DeliveryDay.thursday, DeliveryDay.friday],
      deliveryTime: DeliveryTimeSlot.both,
      lastDeliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      lastPaymentDate: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Customer(
      id: 'cust_004',
      firstName: 'Emma',
      lastName: 'Wilson',
      email: 'emma.wilson@email.com',
      phone: '+91-9876543214',
      address: '321 Elm Street',
      area: 'Residential',
      city: 'Mumbai',
      state: 'Maharashtra',
      zipCode: '400004',
      joinDate: DateTime.now().subtract(const Duration(days: 60)),
      isActive: false,
      creditLimit: 2000.0,
      currentBalance: 0.0,
      deliveryDays: [DeliveryDay.saturday, DeliveryDay.sunday],
      deliveryTime: DeliveryTimeSlot.morning,
      lastDeliveryDate: DateTime.now().subtract(const Duration(days: 45)),
      lastPaymentDate: DateTime.now().subtract(const Duration(days: 45)),
    ),
  ];

  // Mock Deliveries
  static final List<Delivery> _mockDeliveries = [
    Delivery(
      id: 'del_001',
      customerId: 'cust_001',
      customerName: 'John Doe',
      customerPhone: '+91-9876543211',
      deliveryAddress: '123 Main Street, Downtown, Mumbai - 400001',
      deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      deliveryTime: DeliveryTimeSlot.morning,
      status: DeliveryStatus.completed,
      items: [
        DeliveryItem(
          id: 'item_001',
          productId: 'prod_001',
          productName: 'Fresh Cow Milk',
          productUnit: 'Liter',
          quantity: 2.0,
          unitPrice: 60.0,
          totalPrice: 120.0,
        ),
      ],
      totalAmount: 120.0,
      deliveryPerson: 'Ramesh Kumar',
      completedAt: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(hours: 2)),
    ),
    Delivery(
      id: 'del_002',
      customerId: 'cust_002',
      customerName: 'Sarah Smith',
      customerPhone: '+91-9876543212',
      deliveryAddress: '456 Oak Avenue, Suburbs, Mumbai - 400002',
      deliveryDate: DateTime.now().subtract(const Duration(days: 2)),
      deliveryTime: DeliveryTimeSlot.evening,
      status: DeliveryStatus.completed,
      items: [
        DeliveryItem(
          id: 'item_002',
          productId: 'prod_001',
          productName: 'Fresh Cow Milk',
          productUnit: 'Liter',
          quantity: 1.5,
          unitPrice: 60.0,
          totalPrice: 90.0,
        ),
        DeliveryItem(
          id: 'item_003',
          productId: 'prod_003',
          productName: 'Fresh Curd',
          productUnit: 'Kilogram',
          quantity: 0.5,
          unitPrice: 120.0,
          totalPrice: 60.0,
        ),
      ],
      totalAmount: 150.0,
      deliveryPerson: 'Suresh Patel',
      completedAt: DateTime.now().subtract(const Duration(days: 2)).add(const Duration(hours: 3)),
    ),
    Delivery(
      id: 'del_003',
      customerId: 'cust_003',
      customerName: 'Mike Johnson',
      customerPhone: '+91-9876543213',
      deliveryAddress: '789 Pine Road, Industrial, Mumbai - 400003',
      deliveryDate: DateTime.now(),
      deliveryTime: DeliveryTimeSlot.morning,
      status: DeliveryStatus.inProgress,
      items: [
        DeliveryItem(
          id: 'item_004',
          productId: 'prod_001',
          productName: 'Fresh Cow Milk',
          productUnit: 'Liter',
          quantity: 5.0,
          unitPrice: 60.0,
          totalPrice: 300.0,
        ),
        DeliveryItem(
          id: 'item_005',
          productId: 'prod_002',
          productName: 'Buffalo Milk',
          productUnit: 'Liter',
          quantity: 3.0,
          unitPrice: 80.0,
          totalPrice: 240.0,
        ),
      ],
      totalAmount: 540.0,
      deliveryPerson: 'Amit Sharma',
    ),
    Delivery(
      id: 'del_004',
      customerId: 'cust_001',
      customerName: 'John Doe',
      customerPhone: '+91-9876543211',
      deliveryAddress: '123 Main Street, Downtown, Mumbai - 400001',
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
      deliveryTime: DeliveryTimeSlot.morning,
      status: DeliveryStatus.pending,
      items: [
        DeliveryItem(
          id: 'item_006',
          productId: 'prod_001',
          productName: 'Fresh Cow Milk',
          productUnit: 'Liter',
          quantity: 2.0,
          unitPrice: 60.0,
          totalPrice: 120.0,
        ),
      ],
      totalAmount: 120.0,
    ),
  ];

  // Mock Bills
  static final List<Bill> _mockBills = [
    Bill(
      id: 'bill_001',
      customerId: 'cust_001',
      customerName: 'John Doe',
      customerPhone: '+91-9876543211',
      customerAddress: '123 Main Street, Downtown, Mumbai - 400001',
      billNumber: 'INV-2024-001',
      billDate: DateTime.now().subtract(const Duration(days: 30)),
      dueDate: DateTime.now().subtract(const Duration(days: 15)),
      status: BillStatus.overdue,
      items: [
        BillItem(
          id: 'bill_item_001',
          productId: 'prod_001',
          productName: 'Fresh Cow Milk',
          productUnit: 'Liter',
          quantity: 60.0,
          unitPrice: 60.0,
          totalPrice: 3600.0,
        ),
      ],
      subtotal: 3600.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 3600.0,
      paidAmount: 1150.0,
      balanceAmount: 2450.0,
      payments: [
        Payment(
          id: 'pay_001',
          billId: 'bill_001',
          amount: 1150.0,
          method: PaymentMethod.cash,
          paymentDate: DateTime.now().subtract(const Duration(days: 15)),
          reference: 'CASH-001',
        ),
      ],
    ),
    Bill(
      id: 'bill_002',
      customerId: 'cust_002',
      customerName: 'Sarah Smith',
      customerPhone: '+91-9876543212',
      customerAddress: '456 Oak Avenue, Suburbs, Mumbai - 400002',
      billNumber: 'INV-2024-002',
      billDate: DateTime.now().subtract(const Duration(days: 15)),
      dueDate: DateTime.now().add(const Duration(days: 15)),
      status: BillStatus.pending,
      items: [
        BillItem(
          id: 'bill_item_002',
          productId: 'prod_001',
          productName: 'Fresh Cow Milk',
          productUnit: 'Liter',
          quantity: 30.0,
          unitPrice: 60.0,
          totalPrice: 1800.0,
        ),
        BillItem(
          id: 'bill_item_003',
          productId: 'prod_003',
          productName: 'Fresh Curd',
          productUnit: 'Kilogram',
          quantity: 2.0,
          unitPrice: 120.0,
          totalPrice: 240.0,
        ),
      ],
      subtotal: 2040.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 2040.0,
      paidAmount: 840.0,
      balanceAmount: 1200.0,
      payments: [
        Payment(
          id: 'pay_002',
          billId: 'bill_002',
          amount: 840.0,
          method: PaymentMethod.upi,
          paymentDate: DateTime.now().subtract(const Duration(days: 7)),
          reference: 'UPI-123456789',
        ),
      ],
    ),
    Bill(
      id: 'bill_003',
      customerId: 'cust_003',
      customerName: 'Mike Johnson',
      customerPhone: '+91-9876543213',
      customerAddress: '789 Pine Road, Industrial, Mumbai - 400003',
      billNumber: 'INV-2024-003',
      billDate: DateTime.now().subtract(const Duration(days: 7)),
      dueDate: DateTime.now().add(const Duration(days: 23)),
      status: BillStatus.pending,
      items: [
        BillItem(
          id: 'bill_item_004',
          productId: 'prod_001',
          productName: 'Fresh Cow Milk',
          productUnit: 'Liter',
          quantity: 150.0,
          unitPrice: 60.0,
          totalPrice: 9000.0,
        ),
        BillItem(
          id: 'bill_item_005',
          productId: 'prod_002',
          productName: 'Buffalo Milk',
          productUnit: 'Liter',
          quantity: 100.0,
          unitPrice: 80.0,
          totalPrice: 8000.0,
        ),
      ],
      subtotal: 17000.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 17000.0,
      paidAmount: 9500.0,
      balanceAmount: 7500.0,
      payments: [
        Payment(
          id: 'pay_003',
          billId: 'bill_003',
          amount: 5000.0,
          method: PaymentMethod.bankTransfer,
          paymentDate: DateTime.now().subtract(const Duration(days: 5)),
          reference: 'TXN-987654321',
        ),
        Payment(
          id: 'pay_004',
          billId: 'bill_003',
          amount: 4500.0,
          method: PaymentMethod.cheque,
          paymentDate: DateTime.now().subtract(const Duration(days: 2)),
          reference: 'CHQ-123456',
        ),
      ],
    ),
  ];

  // Getters for mock data
  static List<User> get users => List.unmodifiable(_mockUsers);
  static List<Customer> get customers => List.unmodifiable(_mockCustomers);
  static List<Delivery> get deliveries => List.unmodifiable(_mockDeliveries);
  static List<Bill> get bills => List.unmodifiable(_mockBills);
  static List<Product> get products => List.unmodifiable(_mockProducts);

  // Helper methods
  static List<Customer> getActiveCustomers() {
    return _mockCustomers.where((customer) => customer.isActive).toList();
  }

  static List<Delivery> getTodaysDeliveries() {
    final today = DateTime.now();
    return _mockDeliveries.where((delivery) {
      return delivery.deliveryDate.year == today.year &&
          delivery.deliveryDate.month == today.month &&
          delivery.deliveryDate.day == today.day;
    }).toList();
  }

  static List<Delivery> getPendingDeliveries() {
    return _mockDeliveries.where((delivery) => delivery.isPending).toList();
  }

  static List<Delivery> getCompletedDeliveries() {
    return _mockDeliveries.where((delivery) => delivery.isCompleted).toList();
  }

  static List<Bill> getOverdueBills() {
    return _mockBills.where((bill) => bill.isOverdue).toList();
  }

  static List<Bill> getPendingBills() {
    return _mockBills.where((bill) => bill.isPending).toList();
  }

  static List<Product> getLowStockProducts() {
    return _mockProducts.where((product) => product.hasLowStock).toList();
  }

  static List<Product> getOutOfStockProducts() {
    return _mockProducts.where((product) => product.isOutOfStock).toList();
  }

  // Dashboard statistics
  static Map<String, dynamic> getDashboardStats() {
    final activeCustomers = getActiveCustomers().length;
    final todaysDeliveries = getTodaysDeliveries().length;
    final pendingDeliveries = getPendingDeliveries().length;
    final overdueBills = getOverdueBills();
    final pendingBills = getPendingBills();
    
    final totalRevenue = _mockBills.fold(0.0, (sum, bill) => sum + bill.totalAmount);
    final paidAmount = _mockBills.fold(0.0, (sum, bill) => sum + bill.paidAmount);
    final pendingAmount = _mockBills.fold(0.0, (sum, bill) => sum + bill.balanceAmount);
    
    return {
      'customers': {
        'total': _mockCustomers.length,
        'active': activeCustomers,
        'inactive': _mockCustomers.length - activeCustomers,
      },
      'deliveries': {
        'total': _mockDeliveries.length,
        'today': todaysDeliveries,
        'pending': pendingDeliveries,
        'completed': getCompletedDeliveries().length,
      },
      'billing': {
        'totalRevenue': totalRevenue,
        'paidAmount': paidAmount,
        'pendingAmount': pendingAmount,
        'overdueBills': overdueBills.length,
        'pendingBills': pendingBills.length,
      },
      'credit': {
        'totalCredit': _mockCustomers.fold(0.0, (sum, customer) => sum + customer.creditLimit),
        'usedCredit': _mockCustomers.fold(0.0, (sum, customer) => sum + customer.currentBalance),
        'currentBalance': pendingAmount,
      },
      'revenue': {
        'thisMonth': totalRevenue,
        'lastMonth': totalRevenue * 0.85, // Mock data
        'growth': 15.0, // Mock growth percentage
      },
    };
  }
  
  // Customer dashboard data
  static Map<String, dynamic> getCustomerDashboardData(String customerId) {
    final customer = _mockCustomers.firstWhere((c) => c.id == customerId);
    final customerDeliveries = _mockDeliveries.where((d) => d.customerId == customerId).toList();
    final customerBills = _mockBills.where((b) => b.customerId == customerId).toList();
    
    return {
        'customer': customer,
      'deliveries': customerDeliveries,
      'bills': customerBills,
      'stats': {
        'totalDeliveries': customerDeliveries.length,
        'completedDeliveries': customerDeliveries.where((d) => d.isCompleted).length,
        'pendingDeliveries': customerDeliveries.where((d) => d.isPending).length,
        'totalBills': customerBills.length,
        'paidBills': customerBills.where((b) => b.isPaid).length,
        'pendingBills': customerBills.where((b) => b.isPending).length,
        'overdueBills': customerBills.where((b) => b.isOverdue).length,
        'totalSpent': customerBills.fold(0.0, (sum, bill) => sum + bill.totalAmount),
        'totalPaid': customerBills.fold(0.0, (sum, bill) => sum + bill.paidAmount),
        'currentBalance': customerBills.fold(0.0, (sum, bill) => sum + bill.balanceAmount),
      },
    };
  }
}