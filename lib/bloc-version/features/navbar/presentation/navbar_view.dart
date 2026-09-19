import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import '../../batch_list/presentation/batch_list_view.dart';
import '../../create_batch/presentation/create_batch_view.dart';
import '../../profile/presentation/profile_view.dart';
import '../../home/presentation/home_view.dart';
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
      const HomeView(),
      const BatchListView(),
      const CreateBatchView(showBackButton: false),
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
