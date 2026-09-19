import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'data/datasources/app_status_gate_remote_data_source.dart';
import 'data/repositories/app_status_gate_repository.dart';

void initAppMaintenanceDependencies() {
  sl.registerLazySingleton<AppStatusGateRemoteDataSource>(
    () => AppStatusGateRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<AppStatusGateRepository>(
    () => AppStatusGateRepository(
      remoteDataSource: sl<AppStatusGateRemoteDataSource>(),
    ),
  );
}
