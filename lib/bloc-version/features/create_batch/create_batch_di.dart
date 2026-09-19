import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';

import 'data/datasources/create_batch_local_data_source.dart';
import 'data/datasources/create_batch_remote_data_source.dart';
import 'data/repositories/create_batch_repository.dart';
import 'presentation/bloc/create_batch_cubit.dart';

/// Dependency Injection module for CreateBatch feature
void initCreateBatchDependencies() {
  sl.registerLazySingleton<CreateBatchLocalDataSource>(
    () => CreateBatchLocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<CreateBatchRemoteDataSource>(
    () => CreateBatchRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<CreateBatchRepository>(
    () => CreateBatchRepository(
      localDataSource: sl<CreateBatchLocalDataSource>(),
      remoteDataSource: sl<CreateBatchRemoteDataSource>(),
    ),
  );

  sl.registerFactory<CreateBatchCubit>(
    () => CreateBatchCubit(sl<CreateBatchRepository>()),
  );
}
