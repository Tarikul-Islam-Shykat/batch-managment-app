import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'package:batch_management_app_direct/bloc-version/services/router/app_router.dart';
import 'bloc/otp_verification_cubit.dart';
import 'bloc/otp_verification_state.dart';

class OtpVerificationView extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const OtpVerificationView({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtpVerificationCubit>(
      create: (context) => sl<OtpVerificationCubit>(),
      child: _OtpVerificationBody(arguments: arguments),
    );
  }
}

class _OtpVerificationBody extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const _OtpVerificationBody({this.arguments});

  @override
  State<_OtpVerificationBody> createState() => _OtpVerificationBodyState();
}

class _OtpVerificationBodyState extends State<_OtpVerificationBody> {
  final _otpController = TextEditingController();

  late final String email;
  late final String name;
  late final String initialOtp;

  @override
  void initState() {
    super.initState();
    final args = widget.arguments ?? {};
    email = args['email']?.toString() ?? '';
    name = args['name']?.toString() ?? '';

    final signupResp = args['signup_response'] is Map
        ? Map<String, dynamic>.from(args['signup_response'] as Map)
        : <String, dynamic>{};
    initialOtp =
        args['otp']?.toString() ?? (signupResp['otp']?.toString() ?? '');

    if (initialOtp.isNotEmpty) {
      _otpController.text = initialOtp;
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpVerificationCubit, OtpVerificationState>(
      listener: (context, state) {
        if (state is OtpValidationError) {
          AppSnackbar.show(
            context: context,
            message: state.message,
            isSuccess: false,
          );
        } else if (state is OtpVerificationFailure) {
          AppSnackbar.show(
            context: context,
            message: state.errorMessage,
            isSuccess: false,
          );
        } else if (state is OtpResendFailure) {
          AppSnackbar.show(
            context: context,
            message: state.errorMessage,
            isSuccess: false,
          );
        } else if (state is OtpResendSuccess) {
          AppSnackbar.show(
            context: context,
            message: state.message,
            isSuccess: true,
          );
        } else if (state is OtpVerificationSuccess) {
          AppSnackbar.show(
            context: context,
            message: 'OTP verified successfully! Please log in.',
            isSuccess: true,
          );
          context.go(AppRouter.login);
        }
      },
      builder: (context, state) {
        final isVerifying = state is OtpVerificationLoading;
        final isResending = state is OtpResendLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRouter.login);
                }
              },
            ),
            title: Text(
              'OTP Verification',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty
                        ? 'Check your email for OTP'
                        : '$name, check your email',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    email.isEmpty
                        ? 'A 6-digit verification OTP has been sent to your email.'
                        : 'A 6-digit verification OTP has been sent to $email',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 28.h),

                  Row(
                    children: [
                      Text(
                        'OTP Code',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Pinput 6-digit input
                  Center(
                    child: Pinput(
                      controller: _otpController,
                      length: 6,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        context.read<OtpVerificationCubit>().onOtpChanged(val);
                      },
                      defaultPinTheme: PinTheme(
                        width: 48.w,
                        height: 54.w,
                        textStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.12),
                          ),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 48.w,
                        height: 54.w,
                        textStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFF0066FF),
                            width: 1.6,
                          ),
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 48.w,
                        height: 54.w,
                        textStyle: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.12),
                          ),
                        ),
                      ),
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 18.w,
                            height: 2.h,
                            color: const Color(0xFF0066FF),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // Resend OTP Action
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (isResending || isVerifying)
                          ? null
                          : () {
                              context.read<OtpVerificationCubit>().resendOtp(
                                email: email,
                              );
                            },
                      child: isResending
                          ? SizedBox(
                              width: 14.w,
                              height: 14.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF0066FF),
                                ),
                              ),
                            )
                          : Text(
                              'Resend OTP',
                              style: TextStyle(
                                color: const Color(0xFF0066FF),
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Verify OTP Button (Always Enabled)
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed: isVerifying
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              context.read<OtpVerificationCubit>().verifyOtp(
                                email: email,
                                otp: _otpController.text,
                                fallbackRole: 'teacher',
                              );
                            },
                      child: isVerifying
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // Back to Login
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        context.go(AppRouter.login);
                      },
                      child: Text(
                        'Back to Login',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
