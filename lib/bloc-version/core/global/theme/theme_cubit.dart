import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/storage/local/keys.dart';
import '../../../services/storage/local/local_storage_interface.dart';

/// Cubit managing ThemeState (Light / Dark mode toggle) with Local Database Storage
class ThemeCubit extends Cubit<ThemeMode> {
  final ILocalStorageService _localStorage;

  ThemeCubit(this._localStorage) : super(ThemeMode.light) {
    _loadSavedTheme();
  }

  /// Load theme from local database on app startup
  Future<void> _loadSavedTheme() async {
    final savedTheme = await _localStorage.read(LocalStorageKey.themeMode);
    if (savedTheme == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }

  /// Toggle between Light and Dark mode & save to local storage
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newMode);
    await _localStorage.write(
      LocalStorageKey.themeMode,
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  /// Set explicit ThemeMode & save to local storage
  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    await _localStorage.write(
      LocalStorageKey.themeMode,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
