import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/otp_verification_local_data_source.dart';
import '../datasources/otp_verification_remote_data_source.dart';
import '../models/otp_verification_model.dart';

class OtpVerificationRepository {
  final OtpVerificationLocalDataSource _localDataSource;
  final OtpVerificationRemoteDataSource _remoteDataSource;

  OtpVerificationRepository({
    required OtpVerificationLocalDataSource localDataSource,
    required OtpVerificationRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  /// Verifies OTP code and securely stores credentials on success
  Future<Either<Failure, OtpVerificationResponseModel>> verifyOtp({
    required String email,
    required String otp,
    String fallbackRole = 'teacher',
  }) async {
    final result = await _remoteDataSource.verifyOtp(
      email: email.trim(),
      otp: otp.trim(),
    );

    if (result.isSuccess && result.data != null) {
      final responseMap = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};

      final model = OtpVerificationResponseModel.fromJson(responseMap);

      if (model.hasToken) {
        await _localDataSource.saveToken(model.accessToken!);
        final resolvedRole = (model.role != null && model.role!.isNotEmpty)
            ? model.role!
            : fallbackRole;
        await _localDataSource.saveRole(resolvedRole);
      }

      return Right(model);
    }

    return Left(
      ServerFailure(
        result.errorMessage ?? 'OTP verification failed. Please try again.',
      ),
    );
  }

  /// Requests a new OTP to be sent to user's email
  Future<Either<Failure, String>> resendOtp({required String email}) async {
    final result = await _remoteDataSource.resendOtp(email: email.trim());

    if (result.isSuccess) {
      return const Right('A new OTP has been sent to your email.');
    }

    return Left(
      ServerFailure(
        result.errorMessage ?? 'Failed to resend OTP. Please try again.',
      ),
    );
  }
}
