import 'package:luxury_flash/features/flash_drop/domain/entities/flash_product.dart';

class FlashProductModel extends FlashProduct {
  const FlashProductModel({
    required super.id,
    required super.name,
    required super.currentPrice,
    required super.inventory,
    required super.priceHistory,
  });

  factory FlashProductModel.fromJson(Map<String, dynamic> json) {
    return FlashProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      inventory: json['inventory'] as int,
      priceHistory: (json['priceHistory'] as List<dynamic>)
          .map((e) => PricePointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currentPrice': currentPrice,
      'inventory': inventory,
      'priceHistory': priceHistory
          .map((e) => PricePointModel.fromEntity(e).toJson())
          .toList(),
    };
  }

  factory FlashProductModel.fromEntity(FlashProduct entity) {
    return FlashProductModel(
      id: entity.id,
      name: entity.name,
      currentPrice: entity.currentPrice,
      inventory: entity.inventory,
      priceHistory: entity.priceHistory,
    );
  }
}

class PricePointModel extends PricePoint {
  const PricePointModel({
    required super.timestamp,
    required super.price,
  });

  factory PricePointModel.fromJson(Map<String, dynamic> json) {
    return PricePointModel(
      timestamp: DateTime.parse(json['timestamp'] as String),
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'price': price,
    };
  }

  factory PricePointModel.fromEntity(PricePoint entity) {
    return PricePointModel(
      timestamp: entity.timestamp,
      price: entity.price,
    );
  }
}
