import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/register_local_data_source.dart';
import '../datasources/register_remote_data_source.dart';
import '../models/register_model.dart';

class RegisterRepository {
  final RegisterLocalDataSource _localDataSource;
  final RegisterRemoteDataSource _remoteDataSource;

  RegisterRepository({
    required RegisterLocalDataSource localDataSource,
    required RegisterRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  /// Executes Sign Up Action & returns Either<Failure, RegisterResponseModel>
  Future<Either<Failure, RegisterResponseModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.signUp(
      name: name.trim(),
      email: email.trim(),
      password: password,
    );

    if (result.isSuccess && result.data != null) {
      final responseMap = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};

      return Right(RegisterResponseModel.fromJson(responseMap));
    }

    return Left(
      ServerFailure(result.errorMessage ?? 'Registration failed. Please try again.'),
    );
  }
}
