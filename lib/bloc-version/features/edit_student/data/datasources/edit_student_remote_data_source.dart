import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';
import '../models/edit_student_model.dart';

class EditStudentRemoteDataSource {
  final INetworkService _networkService;

  EditStudentRemoteDataSource(this._networkService);

  Future<ApiResult<dynamic>> updateStudent(
    String studentId,
    EditStudentRequestModel payload,
  ) async {
    return await _networkService.patch(
      ApiEndpoints.studentById(studentId),
      data: payload.toJson(),
    );
  }
}
