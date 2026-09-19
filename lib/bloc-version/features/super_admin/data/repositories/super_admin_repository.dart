import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';
import '../datasources/super_admin_remote_data_source.dart';
import '../models/app_status_model.dart';

class SuperAdminRepository {
  final SuperAdminRemoteDataSource _remoteDataSource;

  SuperAdminRepository({required SuperAdminRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  Future<Either<Failure, List<AppStatusModel>>> getAppStatuses() async {
    try {
      final result = await _remoteDataSource.getAppStatuses();

      if (result.isSuccess && result.data != null) {
        final raw = result.data;
        List<dynamic> items = [];

        if (raw is List) {
          items = raw;
        } else if (raw is Map<String, dynamic> && raw['data'] is List) {
          items = raw['data'] as List<dynamic>;
        }

        final statuses = items
            .whereType<Map<String, dynamic>>()
            .map(AppStatusModel.fromJson)
            .toList();

        return Right(statuses);
      }

      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to load app statuses.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> createAppStatus(AppStatusModel model) async {
    try {
      final result = await _remoteDataSource.createAppStatus(model);

      if (result.isSuccess) {
        return const Right(null);
      }

      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to create app status.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updateAppStatus(
    String id,
    AppStatusModel model,
  ) async {
    try {
      final result = await _remoteDataSource.updateAppStatus(id, model);

      if (result.isSuccess) {
        return const Right(null);
      }

      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to update app status.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
