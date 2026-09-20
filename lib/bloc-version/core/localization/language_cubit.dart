import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/storage/local/keys.dart';
import '../../services/storage/local/local_storage_interface.dart';

class LanguageCubit extends Cubit<Locale> {
  final ILocalStorageService _localStorage;

  static const Locale english = Locale('en', 'US');
  static const Locale bangla = Locale('bn', 'BD');

  LanguageCubit(this._localStorage) : super(english) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final saved = await _localStorage.read(LocalStorageKey.language);
      if (saved == 'bn') {
        emit(bangla);
      } else if (saved == 'en') {
        emit(english);
      }
    } catch (_) {}
  }

  bool get isBangla => state.languageCode == 'bn';

  Future<void> toggleLanguage() async {
    final nextLocale = isBangla ? english : bangla;
    emit(nextLocale);
    await _localStorage.write(
      LocalStorageKey.language,
      nextLocale.languageCode,
    );
  }

  Future<void> setLanguage(Locale locale) async {
    emit(locale);
    await _localStorage.write(LocalStorageKey.language, locale.languageCode);
  }
}
