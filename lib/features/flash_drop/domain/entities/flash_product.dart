import 'package:equatable/equatable.dart';

class FlashProduct extends Equatable {
  final String id;
  final String name;
  final double currentPrice;
  final int inventory;
  final List<PricePoint> priceHistory;

  const FlashProduct({
    required this.id,
    required this.name,
    required this.currentPrice,
    required this.inventory,
    required this.priceHistory,
  });

  FlashProduct copyWith({
    String? id,
    String? name,
    double? currentPrice,
    int? inventory,
    List<PricePoint>? priceHistory,
  }) {
    return FlashProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      currentPrice: currentPrice ?? this.currentPrice,
      inventory: inventory ?? this.inventory,
      priceHistory: priceHistory ?? this.priceHistory,
    );
  }

  @override
  List<Object?> get props => [id, name, currentPrice, inventory, priceHistory];
}

class PricePoint extends Equatable {
  final DateTime timestamp;
  final double price;

  const PricePoint({
    required this.timestamp,
    required this.price,
  });

  @override
  List<Object?> get props => [timestamp, price];
}
