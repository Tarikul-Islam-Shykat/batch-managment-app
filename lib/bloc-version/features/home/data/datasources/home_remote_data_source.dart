import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class HomeRemoteDataSource {
  final INetworkService _networkService;

  HomeRemoteDataSource(this._networkService);

  Future<ApiResult<dynamic>> getTeacherDashboard({
    String? month,
    int? recentLimit,
    int? lowSeatThreshold,
  }) async {
    final endpoint = ApiEndpoints.teacherDashboard(
      month: month,
      recentLimit: recentLimit,
      lowSeatThreshold: lowSeatThreshold,
    );
    return await _networkService.get(endpoint);
  }
}
