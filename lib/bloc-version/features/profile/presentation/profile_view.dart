import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'package:batch_management_app_direct/bloc-version/services/router/app_router.dart';
import '../data/models/profile_model.dart';
import 'bloc/profile_cubit.dart';
import 'bloc/profile_state.dart';
import 'widgets/profile_edit_sheet.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => sl<ProfileCubit>()..fetchProfile(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  void _openEditSheet(BuildContext context, UserProfileModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileEditSheet(
        user: user,
        onSave: (payload) async {
          await context.read<ProfileCubit>().updateProfile(payload);
        },
      ),
    );
  }

  Widget _infoCard({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: const Color(0xFF0066FF).withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF0066FF), size: 18.sp),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16.sp,
                    color: const Color(0xFF000710),
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    bool destructive = false,
  }) {
    final color = destructive ? Colors.redAccent : const Color(0xFF000710);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: color),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16.sp,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12.sp,
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22.sp,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          AppSnackbar.show(
            context: context,
            message: state.message,
            isSuccess: true,
          );
        } else if (state is ProfileFailure) {
          AppSnackbar.show(
            context: context,
            message: state.errorMessage,
            isSuccess: false,
          );
        } else if (state is ProfileLoggedOut) {
          AppSnackbar.show(
            context: context,
            message: 'Logged out successfully.',
            isSuccess: true,
          );
          context.go(AppRouter.login);
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoading && state.user == null;
        final user = state.user ?? const UserProfileModel();
        final isSuperAdmin = user.role.toLowerCase() == 'super_admin';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(72.h),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 16.w,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      color: const Color(0xFF000710),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    user.name.isNotEmpty ? user.name : 'Teacher',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => context.read<ProfileCubit>().fetchProfile(),
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xFF000710),
                  ),
                ),
                IconButton(
                  onPressed: () => _openEditSheet(context, user),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF000710),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Center(
                    child: Image.asset(
                      'assets/icon/icon.png',
                      width: 34.w,
                      height: 34.w,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF0066FF)),
                  )
                : RefreshIndicator(
                    color: const Color(0xFF0066FF),
                    onRefresh: () =>
                        context.read<ProfileCubit>().fetchProfile(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gradient Card exactly matching GetX
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(18.w),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0A66FF), Color(0xFF0F172A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(22.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF0066FF,
                                  ).withValues(alpha: 0.16),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 72.w,
                                  height: 72.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 38.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                Text(
                                  user.name.isNotEmpty ? user.name : 'Teacher',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  user.role,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withValues(alpha: 0.82),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (user.email.isNotEmpty) ...[
                                  SizedBox(height: 8.h),
                                  Text(
                                    user.email,
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(
                                        alpha: 0.84,
                                      ),
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          SizedBox(height: 16.h),

                          _infoCard(
                            label: 'Institution Name',
                            value: user.institutionName.isNotEmpty
                                ? user.institutionName
                                : 'Not set',
                            icon: Icons.school_outlined,
                          ),
                          SizedBox(height: 10.h),
                          _infoCard(
                            label: 'Teaching Level',
                            value: user.teachingLevel.isNotEmpty
                                ? user.teachingLevel
                                : 'Not set',
                            icon: Icons.cast_for_education_rounded,
                          ),
                          SizedBox(height: 10.h),
                          _infoCard(
                            label: 'Institution Location',
                            value: user.institutionLocation.isNotEmpty
                                ? user.institutionLocation
                                : 'Not set',
                            icon: Icons.location_on_outlined,
                          ),
                          SizedBox(height: 10.h),
                          _infoCard(
                            label: 'Bio',
                            value: user.bio.isNotEmpty ? user.bio : 'Not set',
                            icon: Icons.notes_rounded,
                          ),

                          if (isSuperAdmin) ...[
                            SizedBox(height: 16.h),
                            _menuTile(
                              icon: Icons.system_update_alt_rounded,
                              title: 'App Status',
                              onTap: () {},
                            ),
                          ],

                          SizedBox(height: 16.h),

                          // Logout Menu Tile
                          _menuTile(
                            icon: Icons.logout_rounded,
                            title: 'Logout',
                            destructive: true,
                            onTap: () => context.read<ProfileCubit>().logout(),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
