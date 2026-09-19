import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/otp_verification_repository.dart';
import 'otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  final OtpVerificationRepository _otpVerificationRepository;

  OtpVerificationCubit(this._otpVerificationRepository)
    : super(const OtpVerificationInitial());

  /// Handles OTP text updates
  void onOtpChanged(String otp) {
    final trimmed = otp.trim();
    final isComplete = trimmed.length == 6;
    emit(OtpVerificationInitial(otp: trimmed, isOtpComplete: isComplete));
  }

  /// Verifies the entered OTP
  Future<void> verifyOtp({
    required String email,
    required String otp,
    String fallbackRole = 'teacher',
  }) async {
    final trimmedEmail = email.trim();
    final trimmedOtp = otp.trim();
    final isComplete = trimmedOtp.length == 6;

    if (trimmedEmail.isEmpty) {
      emit(
        OtpValidationError(
          message: 'Email address is missing.',
          otp: trimmedOtp,
          isOtpComplete: isComplete,
        ),
      );
      return;
    }

    if (trimmedOtp.isEmpty) {
      emit(
        OtpValidationError(
          message: 'Please enter the 6-digit OTP code.',
          otp: trimmedOtp,
          isOtpComplete: false,
        ),
      );
      return;
    }

    if (trimmedOtp.length != 6) {
      emit(
        OtpValidationError(
          message: 'Please enter all 6 digits of the OTP code.',
          otp: trimmedOtp,
          isOtpComplete: false,
        ),
      );
      return;
    }

    emit(OtpVerificationLoading(otp: trimmedOtp, isOtpComplete: true));

    final result = await _otpVerificationRepository.verifyOtp(
      email: trimmedEmail,
      otp: trimmedOtp,
      fallbackRole: fallbackRole,
    );

    result.fold(
      (failure) => emit(
        OtpVerificationFailure(
          errorMessage: failure.message,
          otp: trimmedOtp,
          isOtpComplete: true,
        ),
      ),
      (response) => emit(
        OtpVerificationSuccess(
          response: response,
          otp: trimmedOtp,
          isOtpComplete: true,
        ),
      ),
    );
  }

  /// Requests a new OTP code
  Future<void> resendOtp({required String email}) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      emit(
        OtpValidationError(
          message: 'Email address is missing.',
          otp: state.otp,
          isOtpComplete: state.isOtpComplete,
        ),
      );
      return;
    }

    emit(OtpResendLoading(otp: state.otp, isOtpComplete: state.isOtpComplete));

    final result = await _otpVerificationRepository.resendOtp(
      email: trimmedEmail,
    );

    result.fold(
      (failure) => emit(
        OtpResendFailure(
          errorMessage: failure.message,
          otp: state.otp,
          isOtpComplete: state.isOtpComplete,
        ),
      ),
      (message) => emit(
        OtpResendSuccess(
          message: message,
          otp: state.otp,
          isOtpComplete: state.isOtpComplete,
        ),
      ),
    );
  }
}
