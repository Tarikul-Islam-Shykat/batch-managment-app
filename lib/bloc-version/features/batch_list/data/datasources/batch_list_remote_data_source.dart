import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class BatchListRemoteDataSource {
  final INetworkService _networkService;

  BatchListRemoteDataSource(this._networkService);

  /// Execute BatchList API POST Request
  Future<ApiResult<dynamic>> batchList({
    required String email,
    required String password,
  }) async {
    return await _networkService.post(
      ApiEndpoints.batchList,
      data: {
        'email': email,
        'password': password,
      },
    );
  }
}
