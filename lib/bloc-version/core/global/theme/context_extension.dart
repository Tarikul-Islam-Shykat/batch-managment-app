import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_cubit.dart';

extension ThemeContextExtension on BuildContext {
  /// Check if Dark Mode is active
  bool get isDarkMode => watch<ThemeCubit>().state == ThemeMode.dark;

  /// Get current ThemeMode
  ThemeMode get themeMode => watch<ThemeCubit>().state;

  /// Toggle theme from any button
  void toggleTheme() => read<ThemeCubit>().toggleTheme();
}
