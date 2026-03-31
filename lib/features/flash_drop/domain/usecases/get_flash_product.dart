import 'package:fpdart/fpdart.dart';
import 'package:luxury_flash/core/error/failures.dart';
import 'package:luxury_flash/core/usecase/usecase.dart';
import 'package:luxury_flash/features/flash_drop/domain/entities/flash_product.dart';
import 'package:luxury_flash/features/flash_drop/domain/repositories/flash_repository.dart';

class GetFlashProduct implements Usecase<FlashProduct, String> {
  final FlashRepository repository;

  GetFlashProduct(this.repository);

  @override
  Future<Either<Failure, FlashProduct>> call(String params) async {
    return await repository.getFlashProduct(params);
  }
}
