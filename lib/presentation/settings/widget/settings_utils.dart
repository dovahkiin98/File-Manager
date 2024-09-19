import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';

extension SettingsUtils on BuildContext {
  String getLocaleName(
    Locale? locale,
  ) {
    return switch (locale?.languageCode) {
      'ar' => 'العربية',
      'en' => 'English',
      _ => localizations.system_default,
    };
  }

  String themeModeName(
    ThemeMode themeMode,
  ) {
    return switch (themeMode) {
      ThemeMode.system => localizations.system_default,
      ThemeMode.light => localizations.light,
      ThemeMode.dark => localizations.dark,
    };
  }
}
