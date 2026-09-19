import 'package:get_it/get_it.dart';

import '../../services/network/config/environment.dart';
import '../../services/network/config/network_config.dart';
import '../../services/network/implementations/dio_network_service.dart';
import '../../services/network/interfaces/i_network_service.dart';
import '../../services/storage/local/local_storage_interface.dart';
import '../../services/storage/local/local_storage_service.dart';
import '../../services/storage/secure/secure_storage_interface.dart';
import '../../services/storage/secure/secure_storage_service.dart';
import '../global/theme/theme_cubit.dart';
import '../../features/auth/splash/splash_di.dart';
import '../../features/auth/login/login_di.dart';
import '../../features/auth/register/register_di.dart';
import '../../features/auth/otp_verification/otp_verification_di.dart';
import '../../features/navbar/navbar_di.dart';
import '../../features/profile/profile_di.dart';
import '../../features/create_batch/create_batch_di.dart';
import '../../features/batch_list/batch_list_di.dart';
import '../../features/create_student/create_student_di.dart';
import '../../features/batch_students/batch_students_di.dart';
import '../../features/edit_student/edit_student_di.dart';
import '../../features/super_admin/super_admin_di.dart';
import '../../features/history/history_di.dart';

final sl = GetIt.instance;

/// Initialize all core infrastructure services and feature dependency modules
Future<void> initServiceLocator() async {
  // 1. Core Infrastructure Services
  sl.registerLazySingleton<ISecureStorageService>(() => SecureStorageService());

  sl.registerLazySingleton<ILocalStorageService>(() => LocalStorageService());

  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(sl<ILocalStorageService>()),
  );

  sl.registerLazySingleton<NetworkConfig>(
    () => const NetworkConfig(environment: Environment.dev),
  );

  sl.registerLazySingleton<INetworkService>(
    () => DioNetworkService(
      config: sl<NetworkConfig>(),
      secureStorage: sl<ISecureStorageService>(),
    ),
  );

  // 2. Feature Dependencies
  initSplashDependencies();
  initLoginDependencies();
  initRegisterDependencies();
  initOtpVerificationDependencies();
  initNavbarDependencies();
  initProfileDependencies();
  initCreateBatchDependencies();
  initBatchListDependencies();
  initCreateStudentDependencies();
  initBatchStudentsDependencies();
  initEditStudentDependencies();
  initSuperAdminDependencies();
  initHistoryDependencies();
}
