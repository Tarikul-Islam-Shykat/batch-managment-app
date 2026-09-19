import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/batch_list_local_data_source.dart';
import '../datasources/batch_list_remote_data_source.dart';
import '../models/batch_list_model.dart';

class BatchListRepository {
  final BatchListLocalDataSource localDataSource;
  final BatchListRemoteDataSource remoteDataSource;

  BatchListRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Fetch batches by status with pagination
  Future<Either<Failure, BatchListResponseModel>> getBatches({
    required String status,
    required int page,
    int limit = 10,
  }) async {
    final result = await remoteDataSource.getBatches(
      status: status,
      page: page,
      limit: limit,
    );

    if (result.isSuccess && result.data != null) {
      if (result.data is Map) {
        final parsed = BatchListResponseModel.fromJson(
          Map<String, dynamic>.from(result.data as Map),
        );
        return Right(parsed);
      }
    }

    return Left(
      ServerFailure(result.errorMessage ?? 'Failed to load batches.'),
    );
  }
}
