import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class AppStatusGateRemoteDataSource {
  final INetworkService _networkService;

  AppStatusGateRemoteDataSource(this._networkService);

  Future<ApiResult<dynamic>> getAppStatus() async {
    return await _networkService.get(ApiEndpoints.adminAppStatus);
  }

  Future<ApiResult<dynamic>> getPublicAppStatus() async {
    return await _networkService.get(ApiEndpoints.appStatus);
  }
}
