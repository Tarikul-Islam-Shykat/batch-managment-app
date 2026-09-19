import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/home_dashboard_model.dart';

class HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepository({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  Future<Either<Failure, HomeDashboardModel>> getTeacherDashboard({
    String? month,
    int? recentLimit,
    int? lowSeatThreshold,
  }) async {
    try {
      final result = await _remoteDataSource.getTeacherDashboard(
        month: month,
        recentLimit: recentLimit,
        lowSeatThreshold: lowSeatThreshold,
      );

      if (result.isSuccess && result.data != null) {
        final raw = result.data;
        if (raw is Map<String, dynamic>) {
          return Right(HomeDashboardModel.fromJson(raw));
        } else if (raw is Map) {
          return Right(
            HomeDashboardModel.fromJson(Map<String, dynamic>.from(raw)),
          );
        } else if (raw is List && raw.isNotEmpty) {
          final first = raw.first;
          if (first is Map) {
            return Right(
              HomeDashboardModel.fromJson(Map<String, dynamic>.from(first)),
            );
          }
        }
      }

      return Left(
        ServerFailure(
          result.errorMessage ?? 'Failed to load teacher dashboard.',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
