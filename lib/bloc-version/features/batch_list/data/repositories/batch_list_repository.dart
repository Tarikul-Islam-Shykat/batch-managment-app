import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/batch_list_local_data_source.dart';
import '../datasources/batch_list_remote_data_source.dart';

class BatchListRepository {
  final BatchListLocalDataSource _localDataSource;
  final BatchListRemoteDataSource _remoteDataSource;

  BatchListRepository({
    required BatchListLocalDataSource localDataSource,
    required BatchListRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  /// Executes BatchList Action & returns Either
  Future<Either<Failure, void>> batchList({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.batchList(
      email: email,
      password: password,
    );

    if (result.isSuccess && result.data != null) {
      final responseData = result.data;
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        final token = responseData['data']?['token'];
        if (token != null && token.toString().isNotEmpty) {
          await _localDataSource.clearUserData();
          await _localDataSource.saveToken(token.toString());
        }
        return const Right(null);
      }
      return Left(ServerFailure(responseData['message'] ?? 'BatchList Action failed'));
    }

    return Left(ServerFailure(result.errorMessage ?? 'Network error occurred'));
  }
}
