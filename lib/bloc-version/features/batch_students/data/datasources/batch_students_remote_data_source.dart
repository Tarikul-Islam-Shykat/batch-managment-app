import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';
import '../models/batch_students_model.dart';

class BatchStudentsRemoteDataSource {
  final INetworkService _networkService;

  BatchStudentsRemoteDataSource(this._networkService);

  Future<ApiResult<dynamic>> getStudentsByBatch(String batchId) async {
    return await _networkService.get(ApiEndpoints.studentsByBatch(batchId));
  }

  Future<ApiResult<dynamic>> getFinanceSummary(
    String batchId,
    String month,
  ) async {
    return await _networkService.get(
      ApiEndpoints.financeBatchSummary(batchId, month),
    );
  }

  Future<ApiResult<dynamic>> collectFees(
    BatchFeeCollectRequestModel payload,
  ) async {
    return await _networkService.post(
      ApiEndpoints.financeCollect,
      data: payload.toJson(),
    );
  }
}
