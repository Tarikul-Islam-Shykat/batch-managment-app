import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';
import 'package:batch_management_app_direct/bloc-version/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:batch_management_app_direct/bloc-version/features/profile/presentation/bloc/profile_state.dart';
import 'package:batch_management_app_direct/bloc-version/services/router/app_router.dart';
import '../data/models/app_status_model.dart';
import 'bloc/super_admin_cubit.dart';
import 'bloc/super_admin_state.dart';

class SuperAdminView extends StatelessWidget {
  const SuperAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SuperAdminCubit>(
          create: (context) => sl<SuperAdminCubit>()..fetchStatuses(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => sl<ProfileCubit>()..fetchProfile(),
        ),
      ],
      child: const _SuperAdminBody(),
    );
  }
}

class _SuperAdminBody extends StatelessWidget {
  const _SuperAdminBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuperAdminCubit, SuperAdminState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.show(
            context: context,
            message: state.errorMessage!,
            isSuccess: false,
          );
        }
        if (state.successMessage != null) {
          AppSnackbar.show(
            context: context,
            message: state.successMessage!,
            isSuccess: true,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SuperAdminCubit>();

        final pages = <Widget>[
          const _SuperAdminDashboardTab(),
          _AppStatusTab(cubit: cubit, state: state),
        ];

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: IndexedStack(
            index: state.currentTabIndex,
            children: pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: state.currentTabIndex,
              onDestinationSelected: (index) => cubit.switchTab(index),
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFF0066FF).withValues(alpha: 0.12),
              elevation: 0,
              height: 65.h,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon:
                      Icon(Icons.dashboard_rounded, color: Color(0xFF0066FF)),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.system_update_alt_outlined),
                  selectedIcon: Icon(Icons.system_update_alt_rounded,
                      color: Color(0xFF0066FF)),
                  label: 'App Status',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuperAdminDashboardTab extends StatelessWidget {
  const _SuperAdminDashboardTab();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoggedOut) {
          context.go(AppRouter.login);
        }
      },
      builder: (context, state) {
        final user = state.user;
        final name = user?.name.isNotEmpty == true ? user!.name : 'Super Admin';
        final email = user?.email ?? '';
        final role = user?.role.isNotEmpty == true ? user!.role : 'Super Admin';

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(72.h),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              titleSpacing: 16.w,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Super Admin Dashboard',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18.sp,
                      color: const Color(0xFF000710),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    name,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () =>
                      context.read<ProfileCubit>().fetchProfile(),
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xFF000710),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<ProfileCubit>().fetchProfile(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Overview Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.06),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0066FF)
                                  .withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              role.toUpperCase(),
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11.sp,
                                color: const Color(0xFF0066FF),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            name,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000710),
                            ),
                            maxLines: 2,
                          ),
                          if (email.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              email,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Quick Actions
                    _actionTile(
                      icon: Icons.system_update_alt_rounded,
                      title: 'App Status & Maintenance',
                      subtitle:
                          'Manage active app versions, maintenance messages & downloads',
                      onTap: () {
                        context.read<SuperAdminCubit>().switchTab(1);
                      },
                    ),
                    SizedBox(height: 12.h),
                    _actionTile(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      subtitle: 'Sign out from Super Admin account',
                      destructive: true,
                      onTap: () {
                        context.read<ProfileCubit>().logout();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    final color =
        destructive ? Colors.redAccent : const Color(0xFF0066FF);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: destructive
                            ? Colors.redAccent
                            : const Color(0xFF000710),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppStatusTab extends StatefulWidget {
  final SuperAdminCubit cubit;
  final SuperAdminState state;

  const _AppStatusTab({required this.cubit, required this.state});

  @override
  State<_AppStatusTab> createState() => _AppStatusTabState();
}

class _AppStatusTabState extends State<_AppStatusTab> {
  final _versionController = TextEditingController();
  final _messageController = TextEditingController();
  final _arm64Controller = TextEditingController();
  final _x64Controller = TextEditingController();
  final _aabController = TextEditingController();
  final _lastUpdateController = TextEditingController();
  final _fixesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFromSelection(widget.state.selectedStatus);
  }

  @override
  void didUpdateWidget(covariant _AppStatusTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.selectedStatus != oldWidget.state.selectedStatus) {
      _populateFromSelection(widget.state.selectedStatus);
    }
  }

  void _populateFromSelection(AppStatusModel? model) {
    if (model != null) {
      _versionController.text = model.appVersion;
      _messageController.text = model.appMaintenanceMessage ?? '';
      _arm64Controller.text = model.appUpdateLinks['android_arm64'] ?? '';
      _x64Controller.text = model.appUpdateLinks['android_x64'] ?? '';
      _aabController.text = model.appUpdateLinks['android_aab'] ?? '';
      _lastUpdateController.text = model.appVersionLastUpdate ?? '';
      _fixesController.text = model.appUpdatedFixes.join('\n');
    } else {
      _versionController.clear();
      _messageController.clear();
      _arm64Controller.clear();
      _x64Controller.clear();
      _aabController.clear();
      _lastUpdateController.clear();
      _fixesController.clear();
    }
  }

  @override
  void dispose() {
    _versionController.dispose();
    _messageController.dispose();
    _arm64Controller.dispose();
    _x64Controller.dispose();
    _aabController.dispose();
    _lastUpdateController.dispose();
    _fixesController.dispose();
    super.dispose();
  }

  Widget _buildField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000710),
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.spaceGrotesk(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.spaceGrotesk(
              fontSize: 14.sp,
              color: const Color(0xFF898989),
            ),
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 14.w,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  const BorderSide(color: Color(0xFF0066FF), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = widget.cubit;
    final isUpdating = state.selectedStatus != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 16.w,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'App Status Management',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18.sp,
                  color: const Color(0xFF000710),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                isUpdating ? 'Editing App Version' : 'Create New Status',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            if (isUpdating)
              TextButton(
                onPressed: () {
                  cubit.clearForm();
                  _populateFromSelection(null);
                },
                child: Text(
                  '+ New',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14.sp,
                    color: const Color(0xFF0066FF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            IconButton(
              onPressed: () => cubit.fetchStatuses(),
              icon: const Icon(
                Icons.refresh_rounded,
                color: Color(0xFF000710),
              ),
            ),
            SizedBox(width: 8.w),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => cubit.fetchStatuses(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUpdating ? 'Update App Status' : 'New App Status',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000710),
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // App Version
                      _buildField(
                        controller: _versionController,
                        labelText: 'App Version',
                        hintText: 'e.g. 1.0.0',
                      ),
                      SizedBox(height: 14.h),

                      // Status Type Chips
                      Text(
                        'Status State',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF000710),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Active'),
                            selected: state.selectedStatusType == 'active',
                            selectedColor: const Color(0xFF16A34A),
                            labelStyle: GoogleFonts.spaceGrotesk(
                              color: state.selectedStatusType == 'active'
                                  ? Colors.white
                                  : const Color(0xFF000710),
                              fontWeight: FontWeight.w700,
                            ),
                            backgroundColor: const Color(0xFFF2F2F2),
                            onSelected: (_) => cubit.setStatusType('active'),
                          ),
                          SizedBox(width: 8.w),
                          ChoiceChip(
                            label: const Text('Maintenance'),
                            selected: state.selectedStatusType == 'maintenance',
                            selectedColor: const Color(0xFFF59E0B),
                            labelStyle: GoogleFonts.spaceGrotesk(
                              color: state.selectedStatusType == 'maintenance'
                                  ? Colors.white
                                  : const Color(0xFF000710),
                              fontWeight: FontWeight.w700,
                            ),
                            backgroundColor: const Color(0xFFF2F2F2),
                            onSelected: (_) =>
                                cubit.setStatusType('maintenance'),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),

                      // Maintenance Message
                      _buildField(
                        controller: _messageController,
                        labelText: 'Maintenance Message',
                        hintText: 'We are upgrading servers. Back shortly!',
                        maxLines: 2,
                      ),
                      SizedBox(height: 14.h),

                      // Links
                      _buildField(
                        controller: _arm64Controller,
                        labelText: 'Android ARM64 Download Link',
                        hintText: 'https://...',
                      ),
                      SizedBox(height: 14.h),
                      _buildField(
                        controller: _x64Controller,
                        labelText: 'Android x64 Download Link',
                        hintText: 'https://...',
                      ),
                      SizedBox(height: 14.h),
                      _buildField(
                        controller: _aabController,
                        labelText: 'Android AAB Download Link',
                        hintText: 'https://...',
                      ),
                      SizedBox(height: 14.h),
                      _buildField(
                        controller: _lastUpdateController,
                        labelText: 'Last Update Timestamp',
                        hintText: '2026-09-19T00:00:00Z',
                      ),
                      SizedBox(height: 14.h),
                      _buildField(
                        controller: _fixesController,
                        labelText: 'Changelog / Fixes (One per line)',
                        hintText: 'Bug fixes\nPerformance improvements',
                        maxLines: 3,
                      ),
                      SizedBox(height: 20.h),

                      // Submit Button
                      ElevatedButton(
                        onPressed: state.isSaving
                            ? null
                            : () {
                                cubit.saveStatus(
                                  appVersion: _versionController.text,
                                  maintenanceMessage:
                                      _messageController.text,
                                  arm64Link: _arm64Controller.text,
                                  x64Link: _x64Controller.text,
                                  aabLink: _aabController.text,
                                  lastUpdate: _lastUpdateController.text,
                                  fixesText: _fixesController.text,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: Size.fromHeight(48.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: state.isSaving
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                isUpdating
                                    ? 'Update App Status'
                                    : 'Create App Status',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // History List
                Text(
                  'Configuration History',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000710),
                  ),
                ),
                SizedBox(height: 10.h),
                if (state.isLoading && state.appStatuses.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF0066FF)),
                      ),
                    ),
                  )
                else if (state.appStatuses.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        'No status configurations found.',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                else
                  ...state.appStatuses.map((item) {
                    final isSelected = state.selectedStatus?.id == item.id;
                    final isActive = item.appStatus == 'active';

                    return Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0066FF)
                              : Colors.black.withValues(alpha: 0.06),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          cubit.selectStatus(item);
                          _populateFromSelection(item);
                        },
                        title: Row(
                          children: [
                            Text(
                              'v${item.appVersion}',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF000710),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: (isActive
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFFF59E0B))
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Text(
                                item.appStatus.toUpperCase(),
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: isActive
                                      ? const Color(0xFF16A34A)
                                      : const Color(0xFFF59E0B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: item.appMaintenanceMessage?.isNotEmpty == true
                            ? Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Text(
                                  item.appMaintenanceMessage!,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 12.sp,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : null,
                        trailing: Icon(
                          isSelected
                              ? Icons.edit_note_rounded
                              : Icons.chevron_right_rounded,
                          color: isSelected
                              ? const Color(0xFF0066FF)
                              : Colors.black38,
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
