import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';
import '../models/create_student_model.dart';

class CreateStudentRemoteDataSource {
  final INetworkService _networkService;

  CreateStudentRemoteDataSource(this._networkService);

  /// Enrolls a new student via POST /students
  Future<ApiResult<dynamic>> enrollStudent(
    CreateStudentRequestModel payload,
  ) async {
    return await _networkService.post(
      ApiEndpoints.students,
      data: payload.toJson(),
    );
  }

  /// Fetches active batches to allow selecting a batch if none was passed
  Future<ApiResult<dynamic>> getAvailableBatches() async {
    return await _networkService.get(
      ApiEndpoints.batches,
      queryParameters: {'batch_status': 'current', 'limit': 100},
    );
  }
}
