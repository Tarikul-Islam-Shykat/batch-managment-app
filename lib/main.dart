import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// BLoC Version Imports (Ready to activate when migrating entry point)
import 'bloc-version/core/dependency/service_locator.dart';
import 'bloc-version/services/router/app_router.dart';

import 'core/bindings/controller_binder.dart';
import 'core/localization/app_translations.dart';
import 'core/routes/app_routes.dart';

// ============================================================================
// BLOC VERSION (UNCOMMENT TO SWITCH TO BLOC APP)
// ============================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(const BlocApp());
}

class BlocApp extends StatelessWidget {
  const BlocApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        title: 'Batch Book',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

// ============================================================================
// GETX VERSION (ACTIVE)
// ============================================================================
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812), // base design size (iPhone 13 standard)
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return GetMaterialApp(
//           title: 'Batch Book',
//           debugShowCheckedModeBanner: false,
//           initialRoute: AppRoute.init,
//           getPages: AppRoute.routes,
//           initialBinding: ControllerBinder(),
//           translations: AppTranslations(),
//           locale: const Locale('en', 'US'),
//           fallbackLocale: const Locale('en', 'US'),
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
//           ),
//           home: child,
//         );
//       },
//     );
//   }
// }
