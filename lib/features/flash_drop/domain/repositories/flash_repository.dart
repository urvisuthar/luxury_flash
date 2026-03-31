import 'package:fpdart/fpdart.dart';
import 'package:luxury_flash/core/error/failures.dart';
import 'package:luxury_flash/features/flash_drop/domain/entities/flash_product.dart';

abstract class FlashRepository {
  /// Fetches initial product state and large historical price data.
  Future<Either<Failure, FlashProduct>> getFlashProduct(String id);

  /// Provides real-time stream of product updates.
  Stream<Either<Failure, FlashProduct>> getFlashProductUpdates(String id);

  /// Simulates buying the product.
  Future<Either<Failure, bool>> buyProduct(String id);
}
