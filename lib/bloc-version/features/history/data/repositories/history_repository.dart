import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';
import '../datasources/history_remote_data_source.dart';
import '../models/history_entry_model.dart';

class HistoryRepository {
  final HistoryRemoteDataSource _remoteDataSource;

  HistoryRepository({required HistoryRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  Future<Either<Failure, List<HistoryEntryModel>>> getBatchHistory(
    String batchId,
  ) async {
    try {
      final result = await _remoteDataSource.getBatchHistory(batchId);
      if (result.isSuccess && result.data != null) {
        final items = _extractAndSortItems(result.data);
        return Right(items);
      }
      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to load batch history.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<HistoryEntryModel>>> getStudentHistory(
    String studentId,
  ) async {
    try {
      final result = await _remoteDataSource.getStudentHistory(studentId);
      if (result.isSuccess && result.data != null) {
        final items = _extractAndSortItems(result.data);
        return Right(items);
      }
      return Left(
        ServerFailure(result.errorMessage ?? 'Failed to load student history.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  List<HistoryEntryModel> _extractAndSortItems(dynamic response) {
    final rawItems = <Map<String, dynamic>>[];

    if (response is List) {
      rawItems.addAll(
        response
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
      );
    } else if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      final candidates = [
        map['items'],
        map['entries'],
        map['data'],
        map['history'],
      ];
      for (final candidate in candidates) {
        if (candidate is List) {
          rawItems.addAll(
            candidate
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList(),
          );
          break;
        }
      }

      if (rawItems.isEmpty) {
        rawItems.add(map);
      }
    }

    rawItems.sort((left, right) {
      final leftDate = _parseDate(left['created_at']?.toString() ?? '');
      final rightDate = _parseDate(right['created_at']?.toString() ?? '');
      return rightDate.compareTo(leftDate);
    });

    return rawItems.map(HistoryEntryModel.fromJson).toList();
  }

  DateTime _parseDate(String value) {
    if (value.trim().isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed;
    }

    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss').parse(value);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}
