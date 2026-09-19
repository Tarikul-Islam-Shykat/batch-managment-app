import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';

import 'data/datasources/edit_student_remote_data_source.dart';
import 'data/repositories/edit_student_repository.dart';
import 'presentation/bloc/edit_student_cubit.dart';

void initEditStudentDependencies() {
  sl.registerLazySingleton<EditStudentRemoteDataSource>(
    () => EditStudentRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<EditStudentRepository>(
    () => EditStudentRepository(
      remoteDataSource: sl<EditStudentRemoteDataSource>(),
    ),
  );

  sl.registerFactory<EditStudentCubit>(
    () => EditStudentCubit(sl<EditStudentRepository>()),
  );
}
