part of 'flash_drop_bloc.dart';

@immutable
sealed class FlashDropEvent extends Equatable {
  const FlashDropEvent();

  @override
  List<Object?> get props => [];
}

final class LoadFlashProduct extends FlashDropEvent {
  final String id;
  const LoadFlashProduct(this.id);

  @override
  List<Object?> get props => [id];
}

final class StartPriceUpdates extends FlashDropEvent {
  final String id;
  const StartPriceUpdates(this.id);

  @override
  List<Object?> get props => [id];
}

final class BuyProductRequested extends FlashDropEvent {
  final String id;
  const BuyProductRequested(this.id);

  @override
  List<Object?> get props => [id];
}

final class PriceUpdated extends FlashDropEvent {
  final FlashProduct product;
  const PriceUpdated(this.product);

  @override
  List<Object?> get props => [product];
}
