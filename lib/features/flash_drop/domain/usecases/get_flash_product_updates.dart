import 'package:fpdart/fpdart.dart';
import 'package:luxury_flash/core/error/failures.dart';
import 'package:luxury_flash/core/usecase/usecase.dart';
import 'package:luxury_flash/features/flash_drop/domain/entities/flash_product.dart';
import 'package:luxury_flash/features/flash_drop/domain/repositories/flash_repository.dart';

class GetFlashProductUpdates implements StreamUsecase<FlashProduct, String> {
  final FlashRepository repository;

  GetFlashProductUpdates(this.repository);

  @override
  Stream<Either<Failure, FlashProduct>> call(String params) {
    return repository.getFlashProductUpdates(params);
  }
}
