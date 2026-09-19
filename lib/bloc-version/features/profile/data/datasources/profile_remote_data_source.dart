import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class ProfileRemoteDataSource {
  final INetworkService _networkService;

  ProfileRemoteDataSource(this._networkService);

  /// Fetch user profile
  Future<ApiResult<dynamic>> getProfile() async {
    return await _networkService.get(ApiEndpoints.profileMe);
  }

  /// Update user profile
  Future<ApiResult<dynamic>> updateProfile(Map<String, dynamic> payload) async {
    return await _networkService.patch(
      ApiEndpoints.profileUpdate,
      data: payload,
    );
  }
}
