import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';

import 'data/datasources/navbar_local_data_source.dart';
import 'data/datasources/navbar_remote_data_source.dart';
import 'data/repositories/navbar_repository.dart';
import 'presentation/bloc/navbar_cubit.dart';

/// Dependency Injection module for Navbar feature
void initNavbarDependencies() {
  sl.registerLazySingleton<NavbarLocalDataSource>(
    () => NavbarLocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<NavbarRemoteDataSource>(
    () => NavbarRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<NavbarRepository>(
    () => NavbarRepository(
      localDataSource: sl<NavbarLocalDataSource>(),
      remoteDataSource: sl<NavbarRemoteDataSource>(),
    ),
  );

  sl.registerFactory<NavbarCubit>(() => NavbarCubit());
}
