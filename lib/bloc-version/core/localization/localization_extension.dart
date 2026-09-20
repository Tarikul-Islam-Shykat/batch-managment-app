import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_translations.dart';
import 'language_cubit.dart';

extension LocalizationExtension on BuildContext {
  Locale get currentLocale => watch<LanguageCubit>().state;
  bool get isBangla => watch<LanguageCubit>().isBangla;

  String tr(String key) {
    final loc = watch<LanguageCubit>().state;
    final localeKey = loc.languageCode == 'bn' ? 'bn_BD' : 'en_US';
    return AppTranslations.keys[localeKey]?[key] ??
        AppTranslations.keys['en_US']?[key] ??
        key;
  }
}

extension StringLocalizationExtension on String {
  String tr(BuildContext context) => context.tr(this);
}
