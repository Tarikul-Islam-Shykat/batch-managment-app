import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class BatchListRemoteDataSource {
  final INetworkService _networkService;

  BatchListRemoteDataSource(this._networkService);

  /// Fetch batches by status with pagination
  Future<ApiResult<dynamic>> getBatches({
    required String status,
    required int page,
    required int limit,
  }) async {
    return await _networkService.get(
      ApiEndpoints.batches,
      queryParameters: {'batch_status': status, 'page': page, 'limit': limit},
    );
  }
}
