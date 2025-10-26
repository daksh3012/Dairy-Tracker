import 'package:equatable/equatable.dart';
import '../../core/errors/exceptions.dart';

/// Product category enumeration
enum ProductCategory {
  milk('Milk'),
  curd('Curd'),
  butter('Butter'),
  cheese('Cheese'),
  ghee('Ghee'),
  paneer('Paneer'),
  cream('Cream'),
  yogurt('Yogurt'),
  lassi('Lassi'),
  other('Other');

  const ProductCategory(this.displayName);
  final String displayName;

  static ProductCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'milk':
        return ProductCategory.milk;
      case 'curd':
        return ProductCategory.curd;
      case 'butter':
        return ProductCategory.butter;
      case 'cheese':
        return ProductCategory.cheese;
      case 'ghee':
        return ProductCategory.ghee;
      case 'paneer':
        return ProductCategory.paneer;
      case 'cream':
        return ProductCategory.cream;
      case 'yogurt':
        return ProductCategory.yogurt;
      case 'lassi':
        return ProductCategory.lassi;
      case 'other':
        return ProductCategory.other;
      default:
        throw ValidationException(
          message: 'Invalid product category: $category',
          code: ErrorCodes.invalidFormat,
        );
    }
  }
}

/// Product unit enumeration
enum ProductUnit {
  liter('Liter'),
  kilogram('Kilogram'),
  gram('Gram'),
  piece('Piece'),
  packet('Packet'),
  bottle('Bottle'),
  cup('Cup'),
  serving('Serving');

  const ProductUnit(this.displayName);
  final String displayName;

  static ProductUnit fromString(String unit) {
    switch (unit.toLowerCase()) {
      case 'liter':
      case 'l':
        return ProductUnit.liter;
      case 'kilogram':
      case 'kg':
        return ProductUnit.kilogram;
      case 'gram':
      case 'g':
        return ProductUnit.gram;
      case 'piece':
      case 'pcs':
        return ProductUnit.piece;
      case 'packet':
      case 'pkt':
        return ProductUnit.packet;
      case 'bottle':
        return ProductUnit.bottle;
      case 'cup':
        return ProductUnit.cup;
      case 'serving':
        return ProductUnit.serving;
      default:
        throw ValidationException(
          message: 'Invalid product unit: $unit',
          code: ErrorCodes.invalidFormat,
        );
    }
  }
}

/// Product status enumeration
enum ProductStatus {
  available('Available'),
  unavailable('Unavailable'),
  outOfStock('Out of Stock'),
  lowStock('Low Stock'),
  discontinued('Discontinued');

  const ProductStatus(this.displayName);
  final String displayName;

  static ProductStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return ProductStatus.available;
      case 'unavailable':
        return ProductStatus.unavailable;
      case 'out_of_stock':
      case 'outofstock':
        return ProductStatus.outOfStock;
      case 'low_stock':
      case 'lowstock':
        return ProductStatus.lowStock;
      case 'discontinued':
        return ProductStatus.discontinued;
      default:
        throw ValidationException(
          message: 'Invalid product status: $status',
          code: ErrorCodes.invalidFormat,
        );
    }
  }
}

/// Product model representing dairy products
class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final ProductCategory category;
  final ProductUnit unit;
  final double price;
  final double stock;
  final double minStock;
  final ProductStatus status;
  final String? imageUrl;
  final Map<String, dynamic>? nutritionalInfo;
  final Map<String, dynamic>? specifications;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.unit,
    required this.price,
    required this.stock,
    required this.minStock,
    required this.status,
    this.imageUrl,
    this.nutritionalInfo,
    this.specifications,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  /// Check if product is available
  bool get isAvailable => status == ProductStatus.available && stock > 0;

  /// Check if product is out of stock
  bool get isOutOfStock => status == ProductStatus.outOfStock || stock <= 0;

  /// Check if product has low stock
  bool get hasLowStock => stock <= minStock && stock > 0;

  /// Check if product is discontinued
  bool get isDiscontinued => status == ProductStatus.discontinued;

  /// Stock status
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (hasLowStock) return 'Low Stock';
    if (isDiscontinued) return 'Discontinued';
    return 'In Stock';
  }

  /// Formatted price
  String get formattedPrice => '₹${price.toStringAsFixed(2)}';

  /// Formatted stock
  String get formattedStock => '${stock.toStringAsFixed(1)} ${unit.displayName}';

  /// Formatted minimum stock
  String get formattedMinStock => '${minStock.toStringAsFixed(1)} ${unit.displayName}';

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        unit,
        price,
        stock,
        minStock,
        status,
        imageUrl,
        nutritionalInfo,
        specifications,
        isActive,
        createdAt,
        updatedAt,
        metadata,
      ];

  /// Create a copy of the product with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    ProductCategory? category,
    ProductUnit? unit,
    double? price,
    double? stock,
    double? minStock,
    ProductStatus? status,
    String? imageUrl,
    Map<String, dynamic>? nutritionalInfo,
    Map<String, dynamic>? specifications,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      specifications: specifications ?? this.specifications,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        category: ProductCategory.fromString(json['category'] as String),
        unit: ProductUnit.fromString(json['unit'] as String),
        price: (json['price'] as num).toDouble(),
        stock: (json['stock'] as num).toDouble(),
        minStock: (json['minStock'] as num).toDouble(),
        status: ProductStatus.fromString(json['status'] as String),
        imageUrl: json['imageUrl'] as String?,
        nutritionalInfo: json['nutritionalInfo'] as Map<String, dynamic>?,
        specifications: json['specifications'] as Map<String, dynamic>?,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
    } catch (e) {
      throw ValidationException(
        message: 'Failed to parse product from JSON: $e',
        code: ErrorCodes.validationError,
      );
    }
  }

  /// Convert product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.name,
      'unit': unit.name,
      'price': price,
      'stock': stock,
      'minStock': minStock,
      'status': status.name,
      'imageUrl': imageUrl,
      'nutritionalInfo': nutritionalInfo,
      'specifications': specifications,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Validate product data
  void validate() {
    if (id.isEmpty) {
      throw ValidationException(
        message: 'Product ID cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (name.isEmpty) {
      throw ValidationException(
        message: 'Product name cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (description.isEmpty) {
      throw ValidationException(
        message: 'Product description cannot be empty',
        code: ErrorCodes.requiredField,
      );
    }
    if (price < 0) {
      throw ValidationException(
        message: 'Product price cannot be negative',
        code: ErrorCodes.invalidRange,
      );
    }
    if (stock < 0) {
      throw ValidationException(
        message: 'Product stock cannot be negative',
        code: ErrorCodes.invalidRange,
      );
    }
    if (minStock < 0) {
      throw ValidationException(
        message: 'Minimum stock cannot be negative',
        code: ErrorCodes.invalidRange,
      );
    }
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $formattedPrice, stock: $formattedStock)';
  }
}
