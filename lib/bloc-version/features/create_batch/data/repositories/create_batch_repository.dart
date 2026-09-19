import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/create_batch_local_data_source.dart';
import '../datasources/create_batch_remote_data_source.dart';
import '../models/create_batch_model.dart';

class CreateBatchRepository {
  final CreateBatchLocalDataSource localDataSource;
  final CreateBatchRemoteDataSource remoteDataSource;

  CreateBatchRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Creates a new batch
  Future<Either<Failure, CreateBatchResponseModel>> createBatch(
    CreateBatchRequestModel request,
  ) async {
    final result = await remoteDataSource.createBatch(request);

    if (result.isSuccess && result.data != null) {
      final map = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};
      return Right(CreateBatchResponseModel.fromJson(map));
    }

    return Left(
      ServerFailure(
        result.errorMessage ?? 'Failed to create batch. Please try again.',
      ),
    );
  }

  /// Updates an existing batch
  Future<Either<Failure, CreateBatchResponseModel>> updateBatch({
    required String batchId,
    required Map<String, dynamic> data,
  }) async {
    final result = await remoteDataSource.updateBatch(
      batchId: batchId,
      data: data,
    );

    if (result.isSuccess && result.data != null) {
      final map = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};
      return Right(CreateBatchResponseModel.fromJson(map));
    }

    return Left(
      ServerFailure(
        result.errorMessage ?? 'Failed to update batch. Please try again.',
      ),
    );
  }
}
