import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final ProfileLocalDataSource _localDataSource;
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository({
    required ProfileLocalDataSource localDataSource,
    required ProfileRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  /// Fetches the profile data
  Future<Either<Failure, UserProfileModel>> getProfile() async {
    final result = await _remoteDataSource.getProfile();

    if (result.isSuccess && result.data != null) {
      final map = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};
      final user = UserProfileModel.fromJson(map);
      if (user.role.isNotEmpty) {
        await _localDataSource.saveRole(user.role);
      }
      return Right(user);
    }

    return Left(
      ServerFailure(result.errorMessage ?? 'Failed to load user profile.'),
    );
  }

  /// Updates profile details
  Future<Either<Failure, UserProfileModel>> updateProfile(
    Map<String, dynamic> payload,
  ) async {
    final result = await _remoteDataSource.updateProfile(payload);

    if (result.isSuccess && result.data != null) {
      final map = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};
      final user = UserProfileModel.fromJson(map);
      return Right(user);
    }

    return Left(
      ServerFailure(result.errorMessage ?? 'Failed to update profile.'),
    );
  }

  /// Clears local authentication session
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearUserData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
