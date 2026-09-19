import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';

import 'data/datasources/profile_local_data_source.dart';
import 'data/datasources/profile_remote_data_source.dart';
import 'data/repositories/profile_repository.dart';
import 'presentation/bloc/profile_cubit.dart';

/// Dependency Injection module for Profile feature
void initProfileDependencies() {
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(
      localDataSource: sl<ProfileLocalDataSource>(),
      remoteDataSource: sl<ProfileRemoteDataSource>(),
    ),
  );

  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<ProfileRepository>()));
}
