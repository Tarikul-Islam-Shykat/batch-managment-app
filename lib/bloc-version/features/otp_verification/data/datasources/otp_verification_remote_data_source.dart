import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class OtpVerificationRemoteDataSource {
  final INetworkService _networkService;

  OtpVerificationRemoteDataSource(this._networkService);

  /// Verify OTP API POST Request
  Future<ApiResult<dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _networkService.post(
      ApiEndpoints.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
  }

  /// Request / Resend OTP API POST Request
  Future<ApiResult<dynamic>> resendOtp({required String email}) async {
    return await _networkService.post(
      ApiEndpoints.requestOtp,
      data: {'email': email},
    );
  }
}
