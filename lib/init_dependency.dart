import 'package:get_it/get_it.dart';
import 'package:luxury_flash/features/flash_drop/data/datasources/flash_remote_data_source.dart';
import 'package:luxury_flash/features/flash_drop/data/repositories/flash_repository_impl.dart';
import 'package:luxury_flash/features/flash_drop/domain/repositories/flash_repository.dart';
import 'package:luxury_flash/features/flash_drop/domain/usecases/buy_flash_product.dart';
import 'package:luxury_flash/features/flash_drop/domain/usecases/get_flash_product.dart';
import 'package:luxury_flash/features/flash_drop/domain/usecases/get_flash_product_updates.dart';
import 'package:luxury_flash/features/flash_drop/presentation/bloc/flash_drop_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initFlashDrop();
}

void _initFlashDrop() {
  // Data Sources
  serviceLocator.registerFactory<FlashRemoteDataSource>(
    () => FlashRemoteDataSourceImpl(),
  );

  // Repositories
  serviceLocator.registerFactory<FlashRepository>(
    () => FlashRepositoryImpl(
      remoteDataSource: serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(() => GetFlashProduct(serviceLocator()));
  serviceLocator.registerFactory(() => GetFlashProductUpdates(serviceLocator()));
  serviceLocator.registerFactory(() => BuyFlashProduct(serviceLocator()));

  // Bloc
  serviceLocator.registerLazySingleton(
    () => FlashDropBloc(
      getFlashProduct: serviceLocator(),
      getFlashProductUpdates: serviceLocator(),
      buyFlashProduct: serviceLocator(),
    ),
  );
}
