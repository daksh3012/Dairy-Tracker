import 'package:flutter/foundation.dart';
import '../../../../core/errors/result.dart';
import '../../domain/usecases/get_customer_dashboard_usecase.dart';
import '../../domain/usecases/get_customer_deliveries_usecase.dart';
import '../../domain/usecases/get_customer_bills_usecase.dart';

/// Customer provider for managing customer dashboard data
class CustomerProvider with ChangeNotifier {
  final GetCustomerDashboardUseCase _getCustomerDashboardUseCase;
  final GetCustomerDeliveriesUseCase _getCustomerDeliveriesUseCase;
  final GetCustomerBillsUseCase _getCustomerBillsUseCase;

  CustomerProvider({
    required GetCustomerDashboardUseCase getCustomerDashboardUseCase,
    required GetCustomerDeliveriesUseCase getCustomerDeliveriesUseCase,
    required GetCustomerBillsUseCase getCustomerBillsUseCase,
  })  : _getCustomerDashboardUseCase = getCustomerDashboardUseCase,
        _getCustomerDeliveriesUseCase = getCustomerDeliveriesUseCase,
        _getCustomerBillsUseCase = getCustomerBillsUseCase;

  Map<String, dynamic> _dashboardData = {};
  List<dynamic> _deliveries = [];
  List<dynamic> _bills = [];
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic> get dashboardData => _dashboardData;
  List<dynamic> get deliveries => _deliveries;
  List<dynamic> get bills => _bills;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load customer data
  Future<void> loadCustomerData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load dashboard data
      final dashboardResult = await _getCustomerDashboardUseCase();
      dashboardResult.fold(
        (data) {
          _dashboardData = data;
        },
        (exception) {
          _errorMessage = exception.toString();
        },
      );

      // Load deliveries
      final deliveriesResult = await _getCustomerDeliveriesUseCase();
      deliveriesResult.fold(
        (data) {
          _deliveries = data;
        },
        (exception) {
          _errorMessage = exception.toString();
        },
      );

      // Load bills
      final billsResult = await _getCustomerBillsUseCase();
      billsResult.fold(
        (data) {
          _bills = data;
        },
        (exception) {
          _errorMessage = exception.toString();
        },
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load customer data: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load deliveries
  Future<void> loadDeliveries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getCustomerDeliveriesUseCase();
      result.fold(
        (deliveries) {
          _deliveries = deliveries;
          _isLoading = false;
          notifyListeners();
        },
        (exception) {
          _errorMessage = exception.toString();
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to load deliveries: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load bills
  Future<void> loadBills() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getCustomerBillsUseCase();
      result.fold(
        (bills) {
          _bills = bills;
          _isLoading = false;
          notifyListeners();
        },
        (exception) {
          _errorMessage = exception.toString();
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to load bills: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout customer
  void logout() {
    _dashboardData = {};
    _deliveries = [];
    _bills = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
