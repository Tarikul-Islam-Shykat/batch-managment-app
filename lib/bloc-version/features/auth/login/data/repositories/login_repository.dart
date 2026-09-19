import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/login_local_data_source.dart';
import '../datasources/login_remote_data_source.dart';
import '../models/login_model.dart';

class LoginRepository {
  final LoginLocalDataSource _localDataSource;
  final LoginRemoteDataSource _remoteDataSource;

  LoginRepository({
    required LoginLocalDataSource localDataSource,
    required LoginRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  /// Executes Login Action & persists tokens
  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      email: email.trim(),
      password: password,
    );

    if (result.isSuccess && result.data != null) {
      final responseData = result.data;
      if (responseData is Map) {
        final accessToken = responseData['access_token']?.toString();
        final role = responseData['role']?.toString() ?? 'teacher';

        if (accessToken != null && accessToken.isNotEmpty) {
          await _localDataSource.clearUserData();
          await _localDataSource.saveToken(accessToken);
          await _localDataSource.saveRole(role);
          return Right(
            LoginResponseModel(accessToken: accessToken, role: role),
          );
        }
      }
      return const Left(ServerFailure('Token was not returned by the server.'));
    }

    return Left(
      ServerFailure(result.errorMessage ?? 'Login failed. Please try again.'),
    );
  }
}
