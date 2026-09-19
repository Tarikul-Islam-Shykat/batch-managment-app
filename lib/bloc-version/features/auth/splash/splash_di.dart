import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';

import '../../app_maintenance/data/repositories/app_status_gate_repository.dart';
import 'data/datasources/splash_local_data_source.dart';
import 'data/datasources/splash_remote_data_source.dart';
import 'data/repositories/splash_repository.dart';
import 'presentation/bloc/splash_cubit.dart';

/// Dependency Injection module for Splash feature
void initSplashDependencies() {
  sl.registerLazySingleton<SplashLocalDataSource>(
    () => SplashLocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<SplashRemoteDataSource>(
    () => SplashRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepository(
      localDataSource: sl<SplashLocalDataSource>(),
      remoteDataSource: sl<SplashRemoteDataSource>(),
    ),
  );

  sl.registerFactory<SplashCubit>(
    () => SplashCubit(sl<SplashRepository>(), sl<AppStatusGateRepository>()),
  );
}
