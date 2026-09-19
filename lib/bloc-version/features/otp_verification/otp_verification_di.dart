import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure_storage_interface.dart';

import 'data/datasources/otp_verification_local_data_source.dart';
import 'data/datasources/otp_verification_remote_data_source.dart';
import 'data/repositories/otp_verification_repository.dart';
import 'presentation/bloc/otp_verification_cubit.dart';

/// Dependency Injection module for OtpVerification feature
void initOtpVerificationDependencies() {
  sl.registerLazySingleton<OtpVerificationLocalDataSource>(
    () => OtpVerificationLocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<OtpVerificationRemoteDataSource>(
    () => OtpVerificationRemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<OtpVerificationRepository>(
    () => OtpVerificationRepository(
      localDataSource: sl<OtpVerificationLocalDataSource>(),
      remoteDataSource: sl<OtpVerificationRemoteDataSource>(),
    ),
  );

  sl.registerFactory<OtpVerificationCubit>(
    () => OtpVerificationCubit(sl<OtpVerificationRepository>()),
  );
}
