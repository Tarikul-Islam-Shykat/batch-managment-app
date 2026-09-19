import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';

import 'data/datasources/home_remote_data_source.dart';
import 'data/repositories/home_repository.dart';
import 'presentation/bloc/home_cubit.dart';

void initHomeDependencies() {
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepository(remoteDataSource: sl<HomeRemoteDataSource>()),
  );

  sl.registerFactory<HomeCubit>(
    () => HomeCubit(repository: sl<HomeRepository>()),
  );
}
