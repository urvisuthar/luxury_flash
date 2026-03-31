import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxury_flash/core/error/failures.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

abstract interface class StreamUsecase<SuccessType, Params> {
  Stream<Either<Failure, SuccessType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
