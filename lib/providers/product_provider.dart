import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../utils/mock_data.dart';

/// Product provider for managing product catalog
class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = '';
  bool _showAvailableOnly = true;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get showAvailableOnly => _showAvailableOnly;

  /// Initialize products with mock data
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _products = MockDataService.generateMockProducts();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load products: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new product
  Future<bool> addProduct(Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _products.insert(0, product);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update existing product
  Future<bool> updateProduct(Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Product not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to update product: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete product
  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _products.removeWhere((p) => p.id == productId);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete product: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update product stock
  Future<bool> updateProductStock(String productId, double newStock) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final product = _products[index];
        _products[index] = product.copyWith(
          stockQuantity: newStock,
          updatedAt: DateTime.now(),
        );
        _applyFilters();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Product not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to update stock: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Search products
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// Toggle available products filter
  void toggleAvailableFilter() {
    _showAvailableOnly = !_showAvailableOnly;
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = '';
    _showAvailableOnly = true;
    _applyFilters();
  }

  /// Apply all active filters
  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!product.name.toLowerCase().contains(query) &&
            !product.description.toLowerCase().contains(query) &&
            !product.category.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory.isNotEmpty && product.category != _selectedCategory) {
        return false;
      }

      // Available filter
      if (_showAvailableOnly && !product.isAvailable) {
        return false;
      }

      return true;
    }).toList();

    // Sort by name
    _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  /// Get unique categories for filter dropdown
  List<String> get uniqueCategories {
    return _products
        .map((p) => p.category)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get products by category
  List<Product> getProductsByCategory(String category) {
    return _products
        .where((p) => p.category == category)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Get low stock products
  List<Product> getLowStockProducts() {
    return _products
        .where((p) => p.isLowStock)
        .toList()
      ..sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));
  }

  /// Get product statistics
  Map<String, int> get productStats {
    final total = _products.length;
    final available = _products.where((p) => p.isAvailable).length;
    final unavailable = total - available;
    final lowStock = _products.where((p) => p.isLowStock).length;

    return {
      'total': total,
      'available': available,
      'unavailable': unavailable,
      'lowStock': lowStock,
    };
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
