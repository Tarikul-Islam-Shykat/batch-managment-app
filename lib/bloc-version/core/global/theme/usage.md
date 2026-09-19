# Global Theme Management Guide (`ThemeCubit`)

This guide explains how to set up and use the centralized global theme management system in BLoC Clean Architecture.

---

## 📁 File Structure

```text
lib/bloc-version/core/global/theme/
 ├── theme_cubit.dart          # ThemeCubit state manager
 └── context_extension.dart    # BuildContext extension (context.isDarkMode & context.toggleTheme())
```

---

## 🛠️ Step 1: Register `ThemeCubit` in Service Locator

Open `lib/bloc-version/core/dependency/service_locator.dart` and register `ThemeCubit` as a lazy singleton:

```dart
import '../global/theme/theme_cubit.dart';

Future<void> initServiceLocator() async {
  // Global Services
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  
  // Feature Services...
}
```

---

## 🛠️ Step 2: Provide `ThemeCubit` globally in `main.dart`

Wrap `MaterialApp.router` with `MultiBlocProvider` and `BlocBuilder<ThemeCubit, ThemeMode>` inside `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc-version/core/dependency/service_locator.dart';
import 'bloc-version/core/global/theme/theme_cubit.dart';
import 'bloc-version/services/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => sl<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode, // 🟢 Automatically updates app theme on state change!
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
```

---

## 💻 Step 3: How to Use Theme in ANY Screen or Widget

Import the context extension in any screen file:
```dart
import 'package:batch_management_app_direct/bloc-version/core/global/theme/context_extension.dart';
```

### 1. Check if Dark Mode is Active (Conditional Colors)
```dart
Container(
  color: context.isDarkMode ? Colors.black87 : Colors.white,
  child: Text(
    'Welcome Back',
    style: TextStyle(
      color: context.isDarkMode ? Colors.white : Colors.black,
    ),
  ),
)
```

### 2. Toggle Theme from an IconButton (Light ↔ Dark)
```dart
IconButton(
  icon: Icon(
    context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
    color: Colors.white,
  ),
  onPressed: () {
    context.toggleTheme(); // 🟢 Toggles theme app-wide instantly!
  },
)
```

### 3. Switch Widget in Settings Screen
```dart
SwitchListTile(
  title: const Text('Dark Mode'),
  value: context.isDarkMode,
  onChanged: (_) {
    context.toggleTheme();
  },
)
```
