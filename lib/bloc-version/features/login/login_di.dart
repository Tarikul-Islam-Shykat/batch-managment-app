import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure-storage-interface.dart';

import 'data/datasources/login_local_data_source.dart';
import 'data/datasources/login_remote_data_source.dart';
import 'data/repositories/login_repository.dart';
import 'presentation/bloc/login_cubit.dart';

/// Dependency Injection module for Login feature
void initLoginDependencies() {
  sl.registerLazySingleton<LoginLocalDataSource>(
    () => LoginLocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepository(
      localDataSource: sl<LoginLocalDataSource>(),
      remoteDataSource: sl<LoginRemoteDataSource>(),
    ),
  );

  sl.registerFactory<LoginCubit>(
    () => LoginCubit(sl<LoginRepository>()),
  );
}
