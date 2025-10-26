import 'package:flutter/foundation.dart';
import '../../../../core/errors/result.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/get_customers_usecase.dart';
import '../../domain/usecases/get_deliveries_usecase.dart';
import '../../domain/usecases/get_bills_usecase.dart';

/// Admin provider for managing admin dashboard data
class AdminProvider with ChangeNotifier {
  final GetDashboardStatsUseCase _getDashboardStatsUseCase;
  final GetCustomersUseCase _getCustomersUseCase;
  final GetDeliveriesUseCase _getDeliveriesUseCase;
  final GetBillsUseCase _getBillsUseCase;

  AdminProvider({
    required GetDashboardStatsUseCase getDashboardStatsUseCase,
    required GetCustomersUseCase getCustomersUseCase,
    required GetDeliveriesUseCase getDeliveriesUseCase,
    required GetBillsUseCase getBillsUseCase,
  })  : _getDashboardStatsUseCase = getDashboardStatsUseCase,
        _getCustomersUseCase = getCustomersUseCase,
        _getDeliveriesUseCase = getDeliveriesUseCase,
        _getBillsUseCase = getBillsUseCase;

  Map<String, dynamic> _dashboardStats = {};
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic> get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load dashboard data
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getDashboardStatsUseCase();
      result.fold(
        (stats) {
          _dashboardStats = stats;
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
      _errorMessage = 'Failed to load dashboard data: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load customers data
  Future<void> loadCustomers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getCustomersUseCase();
      result.fold(
        (customers) {
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
      _errorMessage = 'Failed to load customers: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load deliveries data
  Future<void> loadDeliveries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getDeliveriesUseCase();
      result.fold(
        (deliveries) {
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

  /// Load bills data
  Future<void> loadBills() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getBillsUseCase();
      result.fold(
        (bills) {
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

  /// Logout admin
  void logout() {
    _dashboardStats = {};
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
