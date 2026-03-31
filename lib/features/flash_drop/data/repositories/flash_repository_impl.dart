import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:luxury_flash/core/error/exceptions.dart';
import 'package:luxury_flash/core/error/failures.dart';
import 'package:luxury_flash/features/flash_drop/data/datasources/flash_remote_data_source.dart';
import 'package:luxury_flash/features/flash_drop/domain/entities/flash_product.dart';
import 'package:luxury_flash/features/flash_drop/domain/repositories/flash_repository.dart';

class FlashRepositoryImpl implements FlashRepository {
  final FlashRemoteDataSource remoteDataSource;

  FlashRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FlashProduct>> getFlashProduct(String id) async {
    try {
      final result = await remoteDataSource.getFlashProduct(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, FlashProduct>> getFlashProductUpdates(String id) {
    return remoteDataSource.getFlashProductUpdates(id).map(
          (product) => Right<Failure, FlashProduct>(product),
        ).handleError((error) {
          return Left<Failure, FlashProduct>(Failure(error.toString()));
        });
  }

  @override
  Future<Either<Failure, bool>> buyProduct(String id) async {
    try {
      // Simulating API call
      await Future.delayed(const Duration(seconds: 1));
      return const Right(true);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
