import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class RegisterRemoteDataSource {
  final INetworkService _networkService;

  RegisterRemoteDataSource(this._networkService);

  /// Execute Register / Sign Up API POST Request
  Future<ApiResult<dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _networkService.post(
      ApiEndpoints.signUp,
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }
}
