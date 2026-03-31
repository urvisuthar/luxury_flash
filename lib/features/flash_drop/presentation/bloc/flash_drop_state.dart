part of 'flash_drop_bloc.dart';

@immutable
sealed class FlashDropState extends Equatable {
  const FlashDropState();

  @override
  List<Object?> get props => [];
}

final class FlashDropInitial extends FlashDropState {}

final class FlashDropLoading extends FlashDropState {}

final class FlashDropFailure extends FlashDropState {
  final String errorMessage;

  const FlashDropFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class FlashDropSuccess extends FlashDropState {
  final FlashProduct product;
  final List<PricePoint> slidingWindow;

  const FlashDropSuccess({
    required this.product,
    required this.slidingWindow,
  });

  @override
  List<Object?> get props => [product, slidingWindow];
}

final class FlashDropPurchasing extends FlashDropState {
  final FlashProduct product;
  final List<PricePoint> slidingWindow;

  const FlashDropPurchasing({
    required this.product,
    required this.slidingWindow,
  });

  @override
  List<Object?> get props => [product, slidingWindow];
}

final class FlashDropPurchaseSuccess extends FlashDropState {
  final FlashProduct product;
  final List<PricePoint> slidingWindow;

  const FlashDropPurchaseSuccess({
    required this.product,
    required this.slidingWindow,
  });

  @override
  List<Object?> get props => [product, slidingWindow];
}
