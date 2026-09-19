import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';

import 'data/datasources/batch_students_remote_data_source.dart';
import 'data/repositories/batch_students_repository.dart';
import 'presentation/bloc/batch_students_cubit.dart';

void initBatchStudentsDependencies() {
  sl.registerLazySingleton<BatchStudentsRemoteDataSource>(
    () => BatchStudentsRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<BatchStudentsRepository>(
    () => BatchStudentsRepository(
      remoteDataSource: sl<BatchStudentsRemoteDataSource>(),
    ),
  );

  sl.registerFactory<BatchStudentsCubit>(
    () => BatchStudentsCubit(sl<BatchStudentsRepository>()),
  );
}
