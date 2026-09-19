import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/router/app_router.dart';
import 'bloc/splash_cubit.dart';
import 'bloc/splash_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (context) => sl<SplashCubit>()..initSplash(),
      child: const _SplashBody(),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  Widget _buildVersionText() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version ?? '';
        if (version.isEmpty) {
          return const SizedBox.shrink();
        }

        return Text(
          'App Version v$version',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black38,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          context.go(AppRouter.home);
        } else if (state is SplashUnauthenticated) {
          context.go(AppRouter.login);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          'assets/icon/icon.png',
                          width: 120.w,
                          height: 120.w,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.school_rounded,
                            size: 80.sp,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        'BATCH BOOK',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF8A8A8A),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3.2,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ব্যাচবুক',
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: const Color(0xFF1E293B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildVersionText(),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
