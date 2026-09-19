import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class LoginRemoteDataSource {
  final INetworkService _networkService;

  LoginRemoteDataSource(this._networkService);

  /// Execute Login API POST Request
  Future<ApiResult<dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _networkService.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
  }
}
