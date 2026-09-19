import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';

import 'data/datasources/super_admin_remote_data_source.dart';
import 'data/repositories/super_admin_repository.dart';
import 'presentation/bloc/super_admin_cubit.dart';

void initSuperAdminDependencies() {
  sl.registerLazySingleton<SuperAdminRemoteDataSource>(
    () => SuperAdminRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<SuperAdminRepository>(
    () => SuperAdminRepository(
      remoteDataSource: sl<SuperAdminRemoteDataSource>(),
    ),
  );

  sl.registerFactory<SuperAdminCubit>(
    () => SuperAdminCubit(sl<SuperAdminRepository>()),
  );
}
