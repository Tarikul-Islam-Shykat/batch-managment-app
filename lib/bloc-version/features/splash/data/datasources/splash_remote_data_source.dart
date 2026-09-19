import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class SplashRemoteDataSource {
  final INetworkService _networkService;

  SplashRemoteDataSource(this._networkService);

  /// Validates the current session by fetching user profile
  Future<ApiResult<dynamic>> validateSession() async {
    return await _networkService.get(ApiEndpoints.profileMe);
  }
}
