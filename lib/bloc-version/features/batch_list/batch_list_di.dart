import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';

import 'data/datasources/batch_list_local_data_source.dart';
import 'data/datasources/batch_list_remote_data_source.dart';
import 'data/repositories/batch_list_repository.dart';
import 'presentation/bloc/batch_list_cubit.dart';

/// Dependency Injection module for BatchList feature
void initBatchListDependencies() {
  sl.registerLazySingleton<BatchListLocalDataSource>(
    () => BatchListLocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<BatchListRemoteDataSource>(
    () => BatchListRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<BatchListRepository>(
    () => BatchListRepository(
      localDataSource: sl<BatchListLocalDataSource>(),
      remoteDataSource: sl<BatchListRemoteDataSource>(),
    ),
  );

  sl.registerFactory<BatchListCubit>(
    () => BatchListCubit(sl<BatchListRepository>()),
  );
}
