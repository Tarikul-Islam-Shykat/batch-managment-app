import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class HistoryRemoteDataSource {
  final INetworkService _networkService;

  HistoryRemoteDataSource(this._networkService);

  Future<ApiResult<dynamic>> getBatchHistory(String batchId) async {
    return await _networkService.get(ApiEndpoints.batchHistory(batchId));
  }

  Future<ApiResult<dynamic>> getStudentHistory(String studentId) async {
    return await _networkService.get(ApiEndpoints.studentHistory(studentId));
  }
}
