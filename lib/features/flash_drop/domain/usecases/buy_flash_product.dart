import 'package:fpdart/fpdart.dart';
import 'package:luxury_flash/core/error/failures.dart';
import 'package:luxury_flash/core/usecase/usecase.dart';
import 'package:luxury_flash/features/flash_drop/domain/repositories/flash_repository.dart';

class BuyFlashProduct implements Usecase<bool, String> {
  final FlashRepository repository;

  BuyFlashProduct(this.repository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await repository.buyProduct(params);
  }
}
