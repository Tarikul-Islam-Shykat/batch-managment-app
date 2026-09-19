import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';

import 'data/datasources/create_student_remote_data_source.dart';
import 'data/repositories/create_student_repository.dart';
import 'presentation/bloc/create_student_cubit.dart';

/// Dependency Injection module for CreateStudent feature
void initCreateStudentDependencies() {
  sl.registerLazySingleton<CreateStudentRemoteDataSource>(
    () => CreateStudentRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<CreateStudentRepository>(
    () => CreateStudentRepository(
      remoteDataSource: sl<CreateStudentRemoteDataSource>(),
    ),
  );

  sl.registerFactory<CreateStudentCubit>(
    () => CreateStudentCubit(sl<CreateStudentRepository>()),
  );
}
