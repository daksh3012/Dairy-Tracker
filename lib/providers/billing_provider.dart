import 'package:flutter/foundation.dart';
import '../models/billing.dart';
import '../utils/mock_data.dart';

/// Billing provider for managing billing data and operations
class BillingProvider with ChangeNotifier {
  List<Bill> _bills = [];
  List<Bill> _filteredBills = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  BillStatus? _selectedStatus;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  String _selectedCustomerId = '';

  List<Bill> get bills => _bills;
  List<Bill> get filteredBills => _filteredBills;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  BillStatus? get selectedStatus => _selectedStatus;
  DateTime? get selectedDateFrom => _selectedDateFrom;
  DateTime? get selectedDateTo => _selectedDateTo;
  String get selectedCustomerId => _selectedCustomerId;

  /// Initialize bills with mock data
  Future<void> loadBills() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate mock data
      final customers = MockDataService.generateMockCustomers(100);
      final products = MockDataService.generateMockProducts();
      final deliveries = MockDataService.generateMockDeliveries(
        customers,
        products,
        500,
      );
      _bills = MockDataService.generateMockBills(customers, deliveries, 300);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load bills: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generate new bill for customer
  Future<bool> generateBill(
    String customerId,
    DateTime billDate,
    DateTime dueDate,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Create new bill (simplified for demo)
      final bill = Bill(
        id: 'BILL_${DateTime.now().millisecondsSinceEpoch}',
        customerId: customerId,
        customerName: 'Customer Name', // Would be fetched from customer data
        billDate: billDate,
        dueDate: dueDate,
        status: BillStatus.pending,
        items: [],
        subtotal: 0.0,
        totalAmount: 0.0,
        balanceAmount: 0.0,
        createdAt: DateTime.now(),
      );

      _bills.insert(0, bill);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to generate bill: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Add payment to bill
  Future<bool> addPayment(String billId, Payment payment) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _bills.indexWhere((b) => b.id == billId);
      if (index != -1) {
        final bill = _bills[index];
        final updatedPayments = List<Payment>.from(bill.payments)..add(payment);
        final newPaidAmount = bill.paidAmount + payment.amount;
        final newBalanceAmount = bill.totalAmount - newPaidAmount;

        BillStatus newStatus;
        if (newBalanceAmount <= 0) {
          newStatus = BillStatus.paid;
        } else if (newPaidAmount > 0) {
          newStatus = BillStatus.partial;
        } else {
          newStatus = BillStatus.pending;
        }

        _bills[index] = bill.copyWith(
          payments: updatedPayments,
          paidAmount: newPaidAmount,
          balanceAmount: newBalanceAmount,
          status: newStatus,
        );
        _applyFilters();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Bill not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to add payment: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update bill
  Future<bool> updateBill(Bill bill) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _bills.indexWhere((b) => b.id == bill.id);
      if (index != -1) {
        _bills[index] = bill;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Bill not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to update bill: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete bill
  Future<bool> deleteBill(String billId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _bills.removeWhere((b) => b.id == billId);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete bill: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get bill by ID
  Bill? getBillById(String id) {
    try {
      return _bills.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get bills for a specific customer
  List<Bill> getBillsForCustomer(String customerId) {
    return _bills.where((b) => b.customerId == customerId).toList()
      ..sort((a, b) => b.billDate.compareTo(a.billDate));
  }

  /// Get overdue bills
  List<Bill> getOverdueBills() {
    return _bills.where((b) => b.isOverdue).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  /// Get pending payments total
  double getPendingPaymentsTotal() {
    return _bills
        .where(
          (b) =>
              b.status == BillStatus.pending || b.status == BillStatus.overdue,
        )
        .fold(0.0, (sum, bill) => sum + bill.balanceAmount);
  }

  /// Search bills
  void searchBills(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Filter by status
  void filterByStatus(BillStatus? status) {
    _selectedStatus = status;
    _applyFilters();
  }

  /// Filter by date range
  void filterByDateRange(DateTime? from, DateTime? to) {
    _selectedDateFrom = from;
    _selectedDateTo = to;
    _applyFilters();
  }

  /// Filter by customer
  void filterByCustomer(String customerId) {
    _selectedCustomerId = customerId;
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedStatus = null;
    _selectedDateFrom = null;
    _selectedDateTo = null;
    _selectedCustomerId = '';
    _applyFilters();
  }

  /// Apply all active filters
  void _applyFilters() {
    _filteredBills = _bills.where((bill) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!bill.customerName.toLowerCase().contains(query) &&
            !bill.id.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Status filter
      if (_selectedStatus != null && bill.status != _selectedStatus) {
        return false;
      }

      // Date range filter
      if (_selectedDateFrom != null &&
          bill.billDate.isBefore(_selectedDateFrom!)) {
        return false;
      }
      if (_selectedDateTo != null && bill.billDate.isAfter(_selectedDateTo!)) {
        return false;
      }

      // Customer filter
      if (_selectedCustomerId.isNotEmpty &&
          bill.customerId != _selectedCustomerId) {
        return false;
      }

      return true;
    }).toList();

    // Sort by bill date (newest first)
    _filteredBills.sort((a, b) => b.billDate.compareTo(a.billDate));
    notifyListeners();
  }

  /// Get billing statistics
  Map<String, dynamic> get billingStats {
    final total = _bills.length;
    final pending = _bills.where((b) => b.status == BillStatus.pending).length;
    final partial = _bills.where((b) => b.status == BillStatus.partial).length;
    final paid = _bills.where((b) => b.status == BillStatus.paid).length;
    final overdue = _bills.where((b) => b.status == BillStatus.overdue).length;

    final totalAmount = _bills.fold(0.0, (sum, bill) => sum + bill.totalAmount);
    final paidAmount = _bills.fold(0.0, (sum, bill) => sum + bill.paidAmount);
    final pendingAmount = _bills.fold(
      0.0,
      (sum, bill) => sum + bill.balanceAmount,
    );

    return {
      'total': total,
      'pending': pending,
      'partial': partial,
      'paid': paid,
      'overdue': overdue,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'pendingAmount': pendingAmount,
    };
  }

  /// Get monthly revenue
  double getMonthlyRevenue() {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);

    return _bills
        .where(
          (b) =>
              b.billDate.isAfter(thisMonth) &&
              b.billDate.isBefore(nextMonth) &&
              b.status == BillStatus.paid,
        )
        .fold(0.0, (sum, bill) => sum + bill.paidAmount);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
