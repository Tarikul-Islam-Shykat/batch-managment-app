import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import '../../profile/presentation/profile_view.dart';
import 'bloc/navbar_cubit.dart';
import 'bloc/navbar_state.dart';

class NavbarView extends StatelessWidget {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavbarCubit>(
      create: (context) => sl<NavbarCubit>(),
      child: const _NavbarBody(),
    );
  }
}

class _NavbarBody extends StatelessWidget {
  const _NavbarBody();

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _DemoTabPage(
        title: 'Home Dashboard',
        subtitle: 'Home statistics & quick actions (Demo)',
        icon: Icons.home_rounded,
      ),
      const _DemoTabPage(
        title: 'Batches',
        subtitle: 'Batch listing & management (Demo)',
        icon: Icons.view_list_rounded,
      ),
      const _DemoTabPage(
        title: 'New Batch',
        subtitle: 'Create & schedule batch (Demo)',
        icon: Icons.add_circle_rounded,
      ),
      const ProfileView(),
    ];

    return BlocBuilder<NavbarCubit, NavbarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(index: state.currentIndex, children: pages),
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
              selectedIndex: state.currentIndex,
              onDestinationSelected: (index) {
                context.read<NavbarCubit>().selectTab(index);
              },
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFF0066FF).withValues(alpha: 0.12),
              elevation: 0,
              height: 65.h,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: Color(0xFF0066FF)),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.view_list_outlined),
                  selectedIcon: Icon(Icons.view_list, color: Color(0xFF0066FF)),
                  label: 'Batches',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(
                    Icons.add_circle,
                    color: Color(0xFF0066FF),
                  ),
                  label: 'New Batch',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(
                    Icons.person_rounded,
                    color: Color(0xFF0066FF),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DemoTabPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _DemoTabPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36.sp, color: const Color(0xFF0066FF)),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Demo Placeholder',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
