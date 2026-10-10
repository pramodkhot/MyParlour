import 'json.dart';

enum ProductUnit { pcs, ml, g }

enum StockLevel { inStock, low, out }

class Product {
  const Product({
    required this.id,
    required this.parlourId,
    required this.name,
    this.category,
    required this.unit,
    this.sellingPricePaise,
    this.costPricePaise,
    required this.stockQty,
    required this.lowStockAt,
    this.isActive = true,
  });

  factory Product.fromJson(Json json) => Product(
    id: json['id']! as String,
    parlourId: json['parlourId']! as String,
    name: json['name']! as String,
    category: json['category'] as String?,
    unit: enumFromJson(ProductUnit.values, json['unit']),
    sellingPricePaise: json['sellingPricePaise'] as int?,
    costPricePaise: json['costPricePaise'] as int?,
    stockQty: json['stockQty']! as int,
    lowStockAt: json['lowStockAt']! as int,
    isActive: json['isActive'] as bool? ?? true,
  );

  final String id;
  final String parlourId;
  final String name;
  final String? category;
  final ProductUnit unit;
  final int? sellingPricePaise;
  final int? costPricePaise;
  final int stockQty;

  /// Alert when [stockQty] is at or below this number.
  final int lowStockAt;
  final bool isActive;

  StockLevel get stockLevel {
    if (stockQty <= 0) return StockLevel.out;
    if (stockQty <= lowStockAt) return StockLevel.low;
    return StockLevel.inStock;
  }

  /// True for low or out of stock (stockQty ≤ lowStockAt).
  bool get needsRestock => stockQty <= lowStockAt;

  Product copyWith({String? parlourId, int? stockQty, bool? isActive}) =>
      Product(
        id: id,
        parlourId: parlourId ?? this.parlourId,
        name: name,
        category: category,
        unit: unit,
        sellingPricePaise: sellingPricePaise,
        costPricePaise: costPricePaise,
        stockQty: stockQty ?? this.stockQty,
        lowStockAt: lowStockAt,
        isActive: isActive ?? this.isActive,
      );

  Json toJson() => compact({
    'id': id,
    'parlourId': parlourId,
    'name': name,
    'category': category,
    'unit': unit.name,
    'sellingPricePaise': sellingPricePaise,
    'costPricePaise': costPricePaise,
    'stockQty': stockQty,
    'lowStockAt': lowStockAt,
    'isActive': isActive,
  });
}
