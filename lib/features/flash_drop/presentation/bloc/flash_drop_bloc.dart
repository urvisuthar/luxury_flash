import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:luxury_flash/features/flash_drop/domain/entities/flash_product.dart';
import 'package:luxury_flash/features/flash_drop/domain/usecases/buy_flash_product.dart';
import 'package:luxury_flash/features/flash_drop/domain/usecases/get_flash_product.dart';
import 'package:luxury_flash/features/flash_drop/domain/usecases/get_flash_product_updates.dart';

part 'flash_drop_event.dart';
part 'flash_drop_state.dart';

class FlashDropBloc extends Bloc<FlashDropEvent, FlashDropState> {
  final GetFlashProduct _getFlashProduct;
  final GetFlashProductUpdates _getFlashProductUpdates;
  final BuyFlashProduct _buyFlashProduct;
  
  StreamSubscription? _updateSubscription;
  static const int _maxWindowSize = 300;

  FlashDropBloc({
    required GetFlashProduct getFlashProduct,
    required GetFlashProductUpdates getFlashProductUpdates,
    required BuyFlashProduct buyFlashProduct,
  })  : _getFlashProduct = getFlashProduct,
        _getFlashProductUpdates = getFlashProductUpdates,
        _buyFlashProduct = buyFlashProduct,
        super(FlashDropInitial()) {
    on<LoadFlashProduct>(_onLoadProduct);
    on<StartPriceUpdates>(_onStartUpdates);
    on<PriceUpdated>(_onPriceUpdated);
    on<BuyProductRequested>(_onBuyProduct);
  }

  Future<void> _onLoadProduct(LoadFlashProduct event, Emitter<FlashDropState> emit) async {
    emit(FlashDropLoading());
    
    final result = await _getFlashProduct(event.id);

    result.fold(
      (failure) => emit(FlashDropFailure(failure.message)),
      (product) {
        final initialWindow = product.priceHistory.length > _maxWindowSize
            ? product.priceHistory.sublist(product.priceHistory.length - _maxWindowSize)
            : product.priceHistory;

        emit(FlashDropSuccess(
          product: product,
          slidingWindow: initialWindow,
        ));
        
        add(StartPriceUpdates(event.id));
      },
    );
  }

  Future<void> _onStartUpdates(StartPriceUpdates event, Emitter<FlashDropState> emit) async {
    await _updateSubscription?.cancel();
    _updateSubscription = _getFlashProductUpdates(event.id).listen((result) {
      result.fold(
        (failure) {},
        (product) => add(PriceUpdated(product)),
      );
    });
  }

  void _onPriceUpdated(PriceUpdated event, Emitter<FlashDropState> emit) {
    final currentState = state;
    if (currentState is! FlashDropSuccess && 
        currentState is! FlashDropPurchasing && 
        currentState is! FlashDropPurchaseSuccess) return;

    // A helper to get current data regardless of the active state class
    FlashProduct currentProduct;
    List<PricePoint> currentWindow;

    if (currentState is FlashDropSuccess) {
      currentProduct = currentState.product;
      currentWindow = currentState.slidingWindow;
    } else if (currentState is FlashDropPurchasing) {
      currentProduct = currentState.product;
      currentWindow = currentState.slidingWindow;
    } else {
      currentProduct = (currentState as FlashDropPurchaseSuccess).product;
      currentWindow = currentState.slidingWindow;
    }

    final newPoint = PricePoint(
      timestamp: DateTime.now(),
      price: event.product.currentPrice,
    );

    final List<PricePoint> updatedWindow = List.from(currentWindow);
    updatedWindow.add(newPoint);
    if (updatedWindow.length > _maxWindowSize) {
      updatedWindow.removeAt(0);
    }

    final updatedProduct = currentProduct.copyWith(
      currentPrice: event.product.currentPrice,
      inventory: event.product.inventory,
    );

    // Maintain the active state type but with updated data
    if (currentState is FlashDropSuccess) {
      emit(FlashDropSuccess(product: updatedProduct, slidingWindow: updatedWindow));
    } else if (currentState is FlashDropPurchasing) {
      emit(FlashDropPurchasing(product: updatedProduct, slidingWindow: updatedWindow));
    } else {
      emit(FlashDropPurchaseSuccess(product: updatedProduct, slidingWindow: updatedWindow));
    }
  }

  Future<void> _onBuyProduct(BuyProductRequested event, Emitter<FlashDropState> emit) async {
    final currentState = state;
    if (currentState is! FlashDropSuccess) return;

    emit(FlashDropPurchasing(
      product: currentState.product,
      slidingWindow: currentState.slidingWindow,
    ));
    
    final result = await _buyFlashProduct(event.id);

    result.fold(
      (failure) => emit(FlashDropFailure(failure.message)),
      (success) {
        if (success) {
          final newState = state; // Re-get because data might have updated via PriceUpdated
          if (newState is FlashDropPurchasing) {
            emit(FlashDropPurchaseSuccess(
              product: newState.product,
              slidingWindow: newState.slidingWindow,
            ));
          }
        } else {
          emit(const FlashDropFailure("Purchase failed"));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _updateSubscription?.cancel();
    return super.close();
  }
}
