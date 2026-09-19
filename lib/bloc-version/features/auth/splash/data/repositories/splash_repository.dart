import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/splash_local_data_source.dart';
import '../datasources/splash_remote_data_source.dart';
import '../models/splash_model.dart';

class SplashRepository {
  final SplashLocalDataSource _localDataSource;
  final SplashRemoteDataSource _remoteDataSource;

  SplashRepository({
    required SplashLocalDataSource localDataSource,
    required SplashRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  /// Checks local token and validates against remote profile endpoint
  Future<Either<Failure, SessionModel>> checkSession() async {
    final token = await _localDataSource.getToken();
    if (token == null || token.isEmpty) {
      return const Left(CacheFailure('No active session token found.'));
    }

    final result = await _remoteDataSource.validateSession();
    if (result.isSuccess && result.data != null) {
      final data = result.data;
      if (data is Map) {
        final role =
            data['role']?.toString() ??
            await _localDataSource.getRole() ??
            'teacher';
        if (role.isNotEmpty) {
          await _localDataSource.saveRole(role);
        }
        return Right(
          SessionModel(
            token: token,
            role: role,
            name: data['name']?.toString(),
            email: data['email']?.toString(),
          ),
        );
      }
    }

    // If session is expired or invalid, clear local auth data
    await _localDataSource.clearSession();
    return Left(
      ServerFailure(
        result.errorMessage ?? 'Session expired. Please log in again.',
      ),
    );
  }
}
