import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';
import '../models/create_batch_model.dart';

class CreateBatchRemoteDataSource {
  final INetworkService _networkService;

  CreateBatchRemoteDataSource(this._networkService);

  /// Create new batch via POST /batches
  Future<ApiResult<dynamic>> createBatch(
    CreateBatchRequestModel request,
  ) async {
    return await _networkService.post(
      ApiEndpoints.batches,
      data: request.toJson(),
    );
  }

  /// Update existing batch via PUT /batches/{id}
  Future<ApiResult<dynamic>> updateBatch({
    required String batchId,
    required Map<String, dynamic> data,
  }) async {
    return await _networkService.put(
      ApiEndpoints.batchById(batchId),
      data: data,
    );
  }
}
