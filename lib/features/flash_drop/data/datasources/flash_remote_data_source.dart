import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:luxury_flash/features/flash_drop/data/models/flash_product_model.dart';

abstract class FlashRemoteDataSource {
  Future<FlashProductModel> getFlashProduct(String id);
  Stream<FlashProductModel> getFlashProductUpdates(String id);
}

class FlashRemoteDataSourceImpl implements FlashRemoteDataSource {
  final Random _random = Random();
  
  @override
  Future<FlashProductModel> getFlashProduct(String id) async {
    final history = await compute(_generateHistoricalData, 50000);
    
    return FlashProductModel(
      id: id,
      name: "Limited Edition Diamond Watch",
      currentPrice: 25000.0,
      inventory: 50,
      priceHistory: history,
    );
  }

  @override
  Stream<FlashProductModel> getFlashProductUpdates(String id) async* {
    double currentPrice = 25000.0;
    int inventory = 50;

    while (true) {
      await Future.delayed(const Duration(milliseconds: 800));
      
      currentPrice += (_random.nextDouble() - 0.5) * 100;
      if (_random.nextDouble() > 0.9 && inventory > 0) {
        inventory--;
      }

      yield FlashProductModel(
        id: id,
        name: "Limited Edition Diamond Watch",
        currentPrice: currentPrice,
        inventory: inventory,
        priceHistory: const [], 
      );
    }
  }

  static List<PricePointModel> _generateHistoricalData(int count) {
    final List<PricePointModel> history = [];
    final random = Random();
    double price = 24000.0;
    DateTime time = DateTime.now().subtract(Duration(minutes: count));

    for (int i = 0; i < count; i++) {
      price += (random.nextDouble() - 0.5) * 20;
      time = time.add(const Duration(seconds: 1));
      history.add(PricePointModel(timestamp: time, price: price));
    }
    return history;
  }
}
