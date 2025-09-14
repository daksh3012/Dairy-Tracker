import 'package:flutter/foundation.dart';
import '../models/delivery.dart';
import '../models/customer.dart';
import '../models/product.dart';
import '../utils/mock_data.dart';

/// Delivery provider for managing delivery data and operations
class DeliveryProvider with ChangeNotifier {
  List<Delivery> _deliveries = [];
  List<Delivery> _filteredDeliveries = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  DeliveryStatus? _selectedStatus;
  DateTime? _selectedDate;
  String _selectedDeliveryPerson = '';

  List<Delivery> get deliveries => _deliveries;
  List<Delivery> get filteredDeliveries => _filteredDeliveries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  DeliveryStatus? get selectedStatus => _selectedStatus;
  DateTime? get selectedDate => _selectedDate;
  String get selectedDeliveryPerson => _selectedDeliveryPerson;

  /// Initialize deliveries with mock data
  Future<void> loadDeliveries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate mock data
      final customers = MockDataService.generateMockCustomers(100);
      final products = MockDataService.generateMockProducts();
      _deliveries = MockDataService.generateMockDeliveries(customers, products, 500);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load deliveries: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new delivery
  Future<bool> addDelivery(Delivery delivery) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _deliveries.insert(0, delivery);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add delivery: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update existing delivery
  Future<bool> updateDelivery(Delivery delivery) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _deliveries.indexWhere((d) => d.id == delivery.id);
      if (index != -1) {
        _deliveries[index] = delivery;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Delivery not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to update delivery: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Mark delivery as completed
  Future<bool> markDeliveryCompleted(String deliveryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _deliveries.indexWhere((d) => d.id == deliveryId);
      if (index != -1) {
        final delivery = _deliveries[index];
        _deliveries[index] = delivery.copyWith(
          status: DeliveryStatus.completed,
          completedAt: DateTime.now(),
        );
        _applyFilters();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Delivery not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to complete delivery: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete delivery
  Future<bool> deleteDelivery(String deliveryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _deliveries.removeWhere((d) => d.id == deliveryId);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete delivery: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get delivery by ID
  Delivery? getDeliveryById(String id) {
    try {
      return _deliveries.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get deliveries for a specific customer
  List<Delivery> getDeliveriesForCustomer(String customerId) {
    return _deliveries
        .where((d) => d.customerId == customerId)
        .toList()
      ..sort((a, b) => b.deliveryDate.compareTo(a.deliveryDate));
  }

  /// Get deliveries for today
  List<Delivery> getTodaysDeliveries() {
    final today = DateTime.now();
    return _deliveries.where((d) =>
        d.deliveryDate.year == today.year &&
        d.deliveryDate.month == today.month &&
        d.deliveryDate.day == today.day).toList();
  }

  /// Search deliveries
  void searchDeliveries(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Filter by status
  void filterByStatus(DeliveryStatus? status) {
    _selectedStatus = status;
    _applyFilters();
  }

  /// Filter by date
  void filterByDate(DateTime? date) {
    _selectedDate = date;
    _applyFilters();
  }

  /// Filter by delivery person
  void filterByDeliveryPerson(String deliveryPerson) {
    _selectedDeliveryPerson = deliveryPerson;
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedStatus = null;
    _selectedDate = null;
    _selectedDeliveryPerson = '';
    _applyFilters();
  }

  /// Apply all active filters
  void _applyFilters() {
    _filteredDeliveries = _deliveries.where((delivery) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!delivery.customerName.toLowerCase().contains(query) &&
            !delivery.deliveryPerson.toLowerCase().contains(query) &&
            !delivery.id.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Status filter
      if (_selectedStatus != null && delivery.status != _selectedStatus) {
        return false;
      }

      // Date filter
      if (_selectedDate != null) {
        final selected = _selectedDate!;
        if (delivery.deliveryDate.year != selected.year ||
            delivery.deliveryDate.month != selected.month ||
            delivery.deliveryDate.day != selected.day) {
          return false;
        }
      }

      // Delivery person filter
      if (_selectedDeliveryPerson.isNotEmpty && 
          delivery.deliveryPerson != _selectedDeliveryPerson) {
        return false;
      }

      return true;
    }).toList();

    // Sort by delivery date (newest first)
    _filteredDeliveries.sort((a, b) => b.deliveryDate.compareTo(a.deliveryDate));
    notifyListeners();
  }

  /// Get unique delivery persons for filter dropdown
  List<String> get uniqueDeliveryPersons {
    return _deliveries
        .map((d) => d.deliveryPerson)
        .where((person) => person.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get delivery statistics
  Map<String, int> get deliveryStats {
    final total = _deliveries.length;
    final pending = _deliveries.where((d) => d.status == DeliveryStatus.pending).length;
    final inProgress = _deliveries.where((d) => d.status == DeliveryStatus.inProgress).length;
    final completed = _deliveries.where((d) => d.status == DeliveryStatus.completed).length;
    final cancelled = _deliveries.where((d) => d.status == DeliveryStatus.cancelled).length;

    return {
      'total': total,
      'pending': pending,
      'inProgress': inProgress,
      'completed': completed,
      'cancelled': cancelled,
    };
  }

  /// Get today's delivery statistics
  Map<String, int> get todaysDeliveryStats {
    final todaysDeliveries = getTodaysDeliveries();
    final pending = todaysDeliveries.where((d) => d.status == DeliveryStatus.pending).length;
    final inProgress = todaysDeliveries.where((d) => d.status == DeliveryStatus.inProgress).length;
    final completed = todaysDeliveries.where((d) => d.status == DeliveryStatus.completed).length;

    return {
      'total': todaysDeliveries.length,
      'pending': pending,
      'inProgress': inProgress,
      'completed': completed,
    };
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
