import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../utils/mock_data.dart';

/// Customer provider for managing customer data and operations
class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedArea = '';
  String _selectedCity = '';
  bool _showActiveOnly = true;

  List<Customer> get customers => _customers;
  List<Customer> get filteredCustomers => _filteredCustomers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedArea => _selectedArea;
  String get selectedCity => _selectedCity;
  bool get showActiveOnly => _showActiveOnly;

  /// Initialize customers with mock data
  Future<void> loadCustomers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate 2000+ mock customers as requested
      _customers = MockDataService.generateMockCustomers(2000);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load customers: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new customer
  Future<bool> addCustomer(Customer customer) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _customers.insert(0, customer);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add customer: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update existing customer
  Future<bool> updateCustomer(Customer customer) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _customers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _customers[index] = customer;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Customer not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to update customer: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete customer
  Future<bool> deleteCustomer(String customerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _customers.removeWhere((c) => c.id == customerId);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete customer: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get customer by ID
  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search customers
  void searchCustomers(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Filter by area
  void filterByArea(String area) {
    _selectedArea = area;
    _applyFilters();
  }

  /// Filter by city
  void filterByCity(String city) {
    _selectedCity = city;
    _applyFilters();
  }

  /// Toggle active customers filter
  void toggleActiveFilter() {
    _showActiveOnly = !_showActiveOnly;
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedArea = '';
    _selectedCity = '';
    _showActiveOnly = true;
    _applyFilters();
  }

  /// Apply all active filters
  void _applyFilters() {
    _filteredCustomers = _customers.where((customer) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!customer.name.toLowerCase().contains(query) &&
            !customer.phone.contains(query) &&
            !customer.email.toLowerCase().contains(query) &&
            !customer.area.toLowerCase().contains(query) &&
            !customer.city.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Area filter
      if (_selectedArea.isNotEmpty && customer.area != _selectedArea) {
        return false;
      }

      // City filter
      if (_selectedCity.isNotEmpty && customer.city != _selectedCity) {
        return false;
      }

      // Active filter
      if (_showActiveOnly && !customer.isActive) {
        return false;
      }

      return true;
    }).toList();

    // Sort by name
    _filteredCustomers.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  /// Get unique areas for filter dropdown
  List<String> get uniqueAreas {
    return _customers
        .map((c) => c.area)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get unique cities for filter dropdown
  List<String> get uniqueCities {
    return _customers
        .map((c) => c.city)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get customer statistics
  Map<String, int> get customerStats {
    final total = _customers.length;
    final active = _customers.where((c) => c.isActive).length;
    final inactive = total - active;
    final overdue = _customers.where((c) => c.isOverdue).length;

    return {
      'total': total,
      'active': active,
      'inactive': inactive,
      'overdue': overdue,
    };
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
