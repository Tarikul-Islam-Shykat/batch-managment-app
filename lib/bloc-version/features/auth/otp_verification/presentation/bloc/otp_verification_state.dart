import 'package:equatable/equatable.dart';
import '../../data/models/otp_verification_model.dart';

abstract class OtpVerificationState extends Equatable {
  final String otp;
  final bool isOtpComplete;

  const OtpVerificationState({this.otp = '', this.isOtpComplete = false});

  @override
  List<Object?> get props => [otp, isOtpComplete];
}

class OtpVerificationInitial extends OtpVerificationState {
  const OtpVerificationInitial({super.otp, super.isOtpComplete});
}

class OtpVerificationLoading extends OtpVerificationState {
  const OtpVerificationLoading({super.otp, super.isOtpComplete});
}

class OtpVerificationSuccess extends OtpVerificationState {
  final OtpVerificationResponseModel response;

  const OtpVerificationSuccess({
    required this.response,
    super.otp,
    super.isOtpComplete,
  });

  @override
  List<Object?> get props => [response, otp, isOtpComplete];
}

class OtpVerificationFailure extends OtpVerificationState {
  final String errorMessage;

  const OtpVerificationFailure({
    required this.errorMessage,
    super.otp,
    super.isOtpComplete,
  });

  @override
  List<Object?> get props => [errorMessage, otp, isOtpComplete];
}

class OtpResendLoading extends OtpVerificationState {
  const OtpResendLoading({super.otp, super.isOtpComplete});
}

class OtpResendSuccess extends OtpVerificationState {
  final String message;

  const OtpResendSuccess({
    required this.message,
    super.otp,
    super.isOtpComplete,
  });

  @override
  List<Object?> get props => [message, otp, isOtpComplete];
}

class OtpResendFailure extends OtpVerificationState {
  final String errorMessage;

  const OtpResendFailure({
    required this.errorMessage,
    super.otp,
    super.isOtpComplete,
  });

  @override
  List<Object?> get props => [errorMessage, otp, isOtpComplete];
}

class OtpValidationError extends OtpVerificationState {
  final String message;

  const OtpValidationError({
    required this.message,
    super.otp,
    super.isOtpComplete,
  });

  @override
  List<Object?> get props => [message, otp, isOtpComplete];
}
