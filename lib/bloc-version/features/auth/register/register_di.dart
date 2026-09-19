import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';

import 'data/datasources/register_local_data_source.dart';
import 'data/datasources/register_remote_data_source.dart';
import 'data/repositories/register_repository.dart';
import 'presentation/bloc/register_cubit.dart';

/// Dependency Injection module for Register feature
void initRegisterDependencies() {
  sl.registerLazySingleton<RegisterLocalDataSource>(
    () => RegisterLocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepository(
      localDataSource: sl<RegisterLocalDataSource>(),
      remoteDataSource: sl<RegisterRemoteDataSource>(),
    ),
  );

  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(sl<RegisterRepository>()),
  );
}
