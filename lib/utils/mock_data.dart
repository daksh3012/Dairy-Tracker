import 'dart:math';
import '../models/user.dart';
import '../models/customer.dart';
import '../models/product.dart';
import '../models/delivery.dart';
import '../models/billing.dart';

/// Mock data service for testing and development
class MockDataService {
  static final Random _random = Random();
  
  // Generate mock customers (2000+ as requested)
  static List<Customer> generateMockCustomers(int count) {
    final List<String> names = [
      'Rajesh Kumar', 'Priya Sharma', 'Amit Patel', 'Sunita Singh', 'Vikram Gupta',
      'Meera Reddy', 'Suresh Iyer', 'Kavitha Nair', 'Ravi Joshi', 'Anita Desai',
      'Manoj Agarwal', 'Deepa Rao', 'Kiran Mehta', 'Lakshmi Venkat', 'Ramesh Jain',
      'Shobha Menon', 'Gopal Krishnan', 'Uma Pillai', 'Srinivas Reddy', 'Vijaya Kumar',
      'Harish Shetty', 'Radha Iyengar', 'Naveen Gowda', 'Sarita Bhat', 'Prakash Rao',
      'Geeta Nair', 'Suresh Kumar', 'Lakshmi Devi', 'Ravi Shankar', 'Anjali Gupta',
      'Mohan Das', 'Kavita Singh', 'Rajendra Prasad', 'Sunita Devi', 'Vikram Singh',
      'Meera Bai', 'Suresh Babu', 'Kavitha Amma', 'Ravi Kumar', 'Anita Bai',
      'Manoj Singh', 'Deepa Devi', 'Kiran Kumar', 'Lakshmi Bai', 'Ramesh Singh',
      'Shobha Devi', 'Gopal Singh', 'Uma Devi', 'Srinivas Kumar', 'Vijaya Devi',
    ];
    
    final List<String> areas = [
      'Sector 1', 'Sector 2', 'Sector 3', 'Sector 4', 'Sector 5',
      'Civil Lines', 'Model Town', 'Raj Nagar', 'Vasundhara', 'Indirapuram',
      'Noida Extension', 'Greater Noida', 'Ghaziabad', 'Meerut', 'Agra',
      'Mathura', 'Aligarh', 'Bareilly', 'Moradabad', 'Rampur',
    ];
    
    final List<String> cities = [
      'Delhi', 'Noida', 'Gurgaon', 'Ghaziabad', 'Faridabad',
      'Meerut', 'Agra', 'Mathura', 'Aligarh', 'Bareilly',
    ];
    
    final List<List<String>> deliveryDaysOptions = [
      ['monday', 'wednesday', 'friday'],
      ['tuesday', 'thursday', 'saturday'],
      ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'],
      ['monday', 'friday'],
      ['tuesday', 'thursday'],
      ['saturday', 'sunday'],
    ];
    
    final List<String> deliveryTimes = ['morning', 'evening'];
    
    return List.generate(count, (index) {
      final name = names[_random.nextInt(names.length)];
      final area = areas[_random.nextInt(areas.length)];
      final city = cities[_random.nextInt(cities.length)];
      final deliveryDays = deliveryDaysOptions[_random.nextInt(deliveryDaysOptions.length)];
      final deliveryTime = deliveryTimes[_random.nextInt(deliveryTimes.length)];
      
      return Customer(
        id: 'CUST_${(index + 1).toString().padLeft(6, '0')}',
        name: name,
        phone: '9${_random.nextInt(9000000000) + 1000000000}',
        email: '${name.toLowerCase().replaceAll(' ', '.')}@email.com',
        address: 'House No. ${_random.nextInt(999) + 1}, Street ${_random.nextInt(50) + 1}',
        area: area,
        city: city,
        pincode: '${_random.nextInt(900000) + 100000}',
        joinDate: DateTime.now().subtract(Duration(days: _random.nextInt(365 * 3))),
        isActive: _random.nextBool(),
        creditLimit: [3000, 5000, 7000, 10000][_random.nextInt(4)].toDouble(),
        currentBalance: _random.nextDouble() * 5000,
        deliveryDays: deliveryDays,
        deliveryTime: deliveryTime,
        monthlyConsumption: _generateMonthlyConsumption(),
      );
    });
  }
  
  // Generate mock products
  static List<Product> generateMockProducts() {
    return [
      Product(
        id: 'PROD_001',
        name: 'Fresh Cow Milk',
        description: 'Pure and fresh cow milk, pasteurized',
        price: 60.0,
        unit: 'liter',
        category: 'milk',
        stockQuantity: 500.0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'PROD_002',
        name: 'Buffalo Milk',
        description: 'Rich and creamy buffalo milk',
        price: 70.0,
        unit: 'liter',
        category: 'milk',
        stockQuantity: 300.0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'PROD_003',
        name: 'Fresh Curd',
        description: 'Homemade fresh curd',
        price: 50.0,
        unit: 'kg',
        category: 'curd',
        stockQuantity: 200.0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'PROD_004',
        name: 'Butter',
        description: 'Pure white butter',
        price: 400.0,
        unit: 'kg',
        category: 'butter',
        stockQuantity: 50.0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'PROD_005',
        name: 'Paneer',
        description: 'Fresh cottage cheese',
        price: 300.0,
        unit: 'kg',
        category: 'cheese',
        stockQuantity: 100.0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'PROD_006',
        name: 'Ghee',
        description: 'Pure desi ghee',
        price: 500.0,
        unit: 'kg',
        category: 'butter',
        stockQuantity: 75.0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
  
  // Generate mock deliveries
  static List<Delivery> generateMockDeliveries(List<Customer> customers, List<Product> products, int count) {
    final List<DeliveryStatus> statuses = [
      DeliveryStatus.pending,
      DeliveryStatus.inProgress,
      DeliveryStatus.completed,
      DeliveryStatus.cancelled,
    ];
    
    final List<String> deliveryPersons = [
      'Ramesh Kumar', 'Suresh Singh', 'Amit Patel', 'Vikram Gupta', 'Manoj Sharma',
    ];
    
    return List.generate(count, (index) {
      final customer = customers[_random.nextInt(customers.length)];
      final status = statuses[_random.nextInt(statuses.length)];
      final deliveryPerson = deliveryPersons[_random.nextInt(deliveryPersons.length)];
      final deliveryDate = DateTime.now().subtract(Duration(days: _random.nextInt(30)));
      
      // Generate random items
      final itemCount = _random.nextInt(3) + 1;
      final items = <DeliveryItem>[];
      double totalAmount = 0.0;
      
      for (int i = 0; i < itemCount; i++) {
        final product = products[_random.nextInt(products.length)];
        final quantity = _random.nextDouble() * 5 + 0.5;
        final unitPrice = product.price;
        final totalPrice = quantity * unitPrice;
        
        items.add(DeliveryItem(
          productId: product.id,
          productName: product.name,
          quantity: quantity,
          unitPrice: unitPrice,
          totalPrice: totalPrice,
        ));
        
        totalAmount += totalPrice;
      }
      
      return Delivery(
        id: 'DEL_${(index + 1).toString().padLeft(6, '0')}',
        customerId: customer.id,
        customerName: customer.name,
        deliveryDate: deliveryDate,
        status: status,
        items: items,
        totalAmount: totalAmount,
        deliveryPerson: deliveryPerson,
        notes: _random.nextBool() ? 'Special instructions for delivery' : '',
        createdAt: deliveryDate.subtract(const Duration(hours: 2)),
        completedAt: status == DeliveryStatus.completed 
            ? deliveryDate.add(const Duration(hours: 1))
            : null,
      );
    });
  }
  
  // Generate mock bills
  static List<Bill> generateMockBills(List<Customer> customers, List<Delivery> deliveries, int count) {
    final List<BillStatus> statuses = [
      BillStatus.pending,
      BillStatus.partial,
      BillStatus.paid,
      BillStatus.overdue,
    ];
    
    return List.generate(count, (index) {
      final customer = customers[_random.nextInt(customers.length)];
      final status = statuses[_random.nextInt(statuses.length)];
      final billDate = DateTime.now().subtract(Duration(days: _random.nextInt(90)));
      final dueDate = billDate.add(const Duration(days: 30));
      
      // Generate bill items from deliveries
      final customerDeliveries = deliveries
          .where((d) => d.customerId == customer.id && d.isCompleted)
          .take(_random.nextInt(10) + 5)
          .toList();
      
      final items = <BillItem>[];
      double subtotal = 0.0;
      
      for (final delivery in customerDeliveries) {
        for (final item in delivery.items) {
          items.add(BillItem(
            productId: item.productId,
            productName: item.productName,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
            deliveryDate: delivery.deliveryDate,
          ));
          subtotal += item.totalPrice;
        }
      }
      
      final tax = subtotal * 0.05; // 5% tax
      final totalAmount = subtotal + tax;
      final paidAmount = status == BillStatus.paid 
          ? totalAmount 
          : status == BillStatus.partial 
              ? totalAmount * _random.nextDouble() * 0.8
              : 0.0;
      final balanceAmount = totalAmount - paidAmount;
      
      // Generate payments if any
      final payments = <Payment>[];
      if (paidAmount > 0) {
        payments.add(Payment(
          id: 'PAY_${(index + 1).toString().padLeft(6, '0')}',
          billId: 'BILL_${(index + 1).toString().padLeft(6, '0')}',
          amount: paidAmount,
          method: PaymentMethod.values[_random.nextInt(PaymentMethod.values.length)],
          paymentDate: billDate.add(Duration(days: _random.nextInt(30))),
          reference: 'REF${_random.nextInt(999999)}',
          createdAt: billDate.add(Duration(days: _random.nextInt(30))),
        ));
      }
      
      return Bill(
        id: 'BILL_${(index + 1).toString().padLeft(6, '0')}',
        customerId: customer.id,
        customerName: customer.name,
        billDate: billDate,
        dueDate: dueDate,
        status: status,
        items: items,
        subtotal: subtotal,
        tax: tax,
        totalAmount: totalAmount,
        paidAmount: paidAmount,
        balanceAmount: balanceAmount,
        payments: payments,
        notes: _random.nextBool() ? 'Monthly bill for dairy products' : '',
        createdAt: billDate,
      );
    });
  }
  
  // Generate mock users
  static List<User> generateMockUsers() {
    return [
      User(
        id: 'USER_001',
        email: 'admin@dairytrack.com',
        phone: '9876543210',
        name: 'Admin User',
        role: UserRole.admin,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      User(
        id: 'USER_002',
        email: 'manager@dairytrack.com',
        phone: '9876543211',
        name: 'Manager User',
        role: UserRole.admin,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
      ),
    ];
  }
  
  // Helper method to generate monthly consumption
  static Map<String, double> _generateMonthlyConsumption() {
    return {
      'PROD_001': _random.nextDouble() * 100 + 20, // Fresh Cow Milk
      'PROD_002': _random.nextDouble() * 50 + 10,  // Buffalo Milk
      'PROD_003': _random.nextDouble() * 30 + 5,   // Fresh Curd
      'PROD_004': _random.nextDouble() * 5 + 1,    // Butter
      'PROD_005': _random.nextDouble() * 10 + 2,   // Paneer
      'PROD_006': _random.nextDouble() * 3 + 1,    // Ghee
    };
  }
  
  // Get dashboard statistics
  static Map<String, dynamic> getDashboardStats(
    List<Customer> customers,
    List<Delivery> deliveries,
    List<Bill> bills,
  ) {
    final today = DateTime.now();
    final thisMonth = DateTime(today.year, today.month);
    
    final totalCustomers = customers.length;
    final activeCustomers = customers.where((c) => c.isActive).length;
    
    final pendingPayments = bills
        .where((b) => b.status == BillStatus.pending || b.status == BillStatus.overdue)
        .fold(0.0, (sum, bill) => sum + bill.balanceAmount);
    
    final todaysDeliveries = deliveries
        .where((d) => 
            d.deliveryDate.year == today.year &&
            d.deliveryDate.month == today.month &&
            d.deliveryDate.day == today.day)
        .length;
    
    final monthlyRevenue = bills
        .where((b) => 
            b.billDate.year == thisMonth.year &&
            b.billDate.month == thisMonth.month)
        .fold(0.0, (sum, bill) => sum + bill.paidAmount);
    
    return {
      'totalCustomers': totalCustomers,
      'activeCustomers': activeCustomers,
      'pendingPayments': pendingPayments,
      'todaysDeliveries': todaysDeliveries,
      'monthlyRevenue': monthlyRevenue,
    };
  }
}
