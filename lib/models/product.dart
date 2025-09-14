/// Product model for dairy items catalog
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit; // 'liter', 'kg', 'piece', etc.
  final String category; // 'milk', 'curd', 'butter', 'cheese', etc.
  final bool isAvailable;
  final String imageUrl;
  final double stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    this.isAvailable = true,
    this.imageUrl = '',
    this.stockQuantity = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? 'liter',
      category: json['category'] ?? 'milk',
      isAvailable: json['isAvailable'] ?? true,
      imageUrl: json['imageUrl'] ?? '',
      stockQuantity: (json['stockQuantity'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category,
      'isAvailable': isAvailable,
      'imageUrl': imageUrl,
      'stockQuantity': stockQuantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? unit,
    String? category,
    bool? isAvailable,
    String? imageUrl,
    double? stockQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get priceDisplay => '₹${price.toStringAsFixed(2)}/$unit';
  
  bool get isLowStock => stockQuantity < 10.0;
}
