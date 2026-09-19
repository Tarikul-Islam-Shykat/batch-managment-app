import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';
import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import '../datasources/create_student_remote_data_source.dart';
import '../models/create_student_model.dart';

class CreateStudentRepository {
  final CreateStudentRemoteDataSource _remoteDataSource;

  CreateStudentRepository({
    required CreateStudentRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  Future<Either<Failure, CreateStudentResponseModel>> enrollStudent(
    CreateStudentRequestModel payload,
  ) async {
    try {
      final result = await _remoteDataSource.enrollStudent(payload);

      if (result.isSuccess && result.data != null) {
        final data = result.data;
        if (data is Map<String, dynamic>) {
          return Right(CreateStudentResponseModel.fromJson(data));
        }
        return const Right(CreateStudentResponseModel());
      }

      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to enroll student.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<BatchListItemModel>>>
  getAvailableBatches() async {
    try {
      final result = await _remoteDataSource.getAvailableBatches();

      if (result.isSuccess && result.data != null) {
        final raw = result.data;
        List<dynamic> itemsList = [];

        if (raw is Map<String, dynamic>) {
          if (raw['data'] is Map<String, dynamic> &&
              raw['data']['items'] is List) {
            itemsList = raw['data']['items'] as List<dynamic>;
          } else if (raw['data'] is List) {
            itemsList = raw['data'] as List<dynamic>;
          } else if (raw['items'] is List) {
            itemsList = raw['items'] as List<dynamic>;
          }
        } else if (raw is List) {
          itemsList = raw;
        }

        final batches = itemsList
            .whereType<Map<String, dynamic>>()
            .map(BatchListItemModel.fromJson)
            .toList();

        return Right(batches);
      }

      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to fetch batches.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
