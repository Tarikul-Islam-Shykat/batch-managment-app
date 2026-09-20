import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc-version/core/localization/language_cubit.dart';
import 'bloc-version/core/dependency/service_locator.dart';
import 'bloc-version/services/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(const BlocApp());
}

class BlocApp extends StatelessWidget {
  const BlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageCubit>(
      create: (context) => sl<LanguageCubit>(),
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp.router(
              title: 'Batch Book',
              debugShowCheckedModeBanner: false,
              locale: locale,
              routerConfig: AppRouter.router,
              theme: ThemeData(
                useMaterial3: true,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                scaffoldBackgroundColor: const Color(0xFFF8FAFC),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF2563EB),
                  primary: const Color(0xFF2563EB),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
