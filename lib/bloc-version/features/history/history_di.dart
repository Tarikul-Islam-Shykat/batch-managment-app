import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';

import 'data/datasources/history_remote_data_source.dart';
import 'data/repositories/history_repository.dart';
import 'presentation/bloc/history_cubit.dart';

void initHistoryDependencies() {
  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepository(remoteDataSource: sl<HistoryRemoteDataSource>()),
  );

  sl.registerFactory<HistoryCubit>(
    () => HistoryCubit(repository: sl<HistoryRepository>()),
  );
}
