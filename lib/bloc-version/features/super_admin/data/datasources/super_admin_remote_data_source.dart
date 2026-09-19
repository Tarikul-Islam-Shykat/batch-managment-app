import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';
import '../models/app_status_model.dart';

class SuperAdminRemoteDataSource {
  final INetworkService _networkService;

  SuperAdminRemoteDataSource(this._networkService);

  Future<ApiResult<dynamic>> getAppStatuses() async {
    return await _networkService.get(ApiEndpoints.appStatus);
  }

  Future<ApiResult<dynamic>> createAppStatus(AppStatusModel model) async {
    return await _networkService.post(
      ApiEndpoints.adminAppStatus,
      data: model.toCreateJson(),
    );
  }

  Future<ApiResult<dynamic>> updateAppStatus(
    String id,
    AppStatusModel model,
  ) async {
    return await _networkService.put(
      ApiEndpoints.adminAppStatusById(id),
      data: model.toUpdateJson(),
    );
  }
}
