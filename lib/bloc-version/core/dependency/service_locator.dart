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
import '../../features/splash/splash_di.dart';
import '../../features/login/login_di.dart';

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
}
