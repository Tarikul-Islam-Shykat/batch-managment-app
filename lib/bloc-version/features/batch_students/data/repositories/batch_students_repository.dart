import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';
import '../datasources/batch_students_remote_data_source.dart';
import '../models/batch_students_model.dart';

class BatchStudentsRepository {
  final BatchStudentsRemoteDataSource _remoteDataSource;

  BatchStudentsRepository({
    required BatchStudentsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  Future<Either<Failure, List<BatchStudentModel>>> getStudentsByBatch(
    String batchId,
  ) async {
    try {
      final result = await _remoteDataSource.getStudentsByBatch(batchId);

      if (result.isSuccess && result.data != null) {
        final raw = result.data;
        List<dynamic> items = [];

        if (raw is List) {
          items = raw;
        } else if (raw is Map<String, dynamic>) {
          if (raw['data'] is List) {
            items = raw['data'] as List<dynamic>;
          } else if (raw['items'] is List) {
            items = raw['items'] as List<dynamic>;
          }
        }

        final students = items
            .whereType<Map<String, dynamic>>()
            .map(BatchStudentModel.fromJson)
            .toList();

        return Right(students);
      }

      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to load batch students.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, BatchFinanceSummaryModel>> getFinanceSummary(
    String batchId,
    String month,
  ) async {
    try {
      final result = await _remoteDataSource.getFinanceSummary(batchId, month);

      if (result.isSuccess && result.data != null) {
        final raw = result.data;
        if (raw is Map<String, dynamic>) {
          final data = raw['data'] is Map<String, dynamic>
              ? raw['data'] as Map<String, dynamic>
              : raw;
          return Right(BatchFinanceSummaryModel.fromJson(data));
        }
        return const Right(
          BatchFinanceSummaryModel(
            totalStudents: 0,
            paidStudents: 0,
            totalExpectedAmount: 0.0,
            totalPaidAmount: 0.0,
            remainingAmount: 0.0,
          ),
        );
      }

      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to load finance summary.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> collectFees(
    BatchFeeCollectRequestModel payload,
  ) async {
    try {
      final result = await _remoteDataSource.collectFees(payload);

      if (result.isSuccess) {
        return const Right(null);
      }

      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to collect fee.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
