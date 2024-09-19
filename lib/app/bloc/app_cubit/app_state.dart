import 'package:file_manager/core/utils/utils.dart';
import 'package:file_manager/data/model/view_mode.dart';
import 'package:flutter/material.dart';
import 'package:intl/locale.dart' as intl;

final class AppState {
  AppState({
    this.locale,
    required this.themeMode,
    required this.viewMode,
    this.showHiddenFiles = false,
  });

  final Locale? locale;
  final ThemeMode themeMode;
  final ViewMode viewMode;
  final bool showHiddenFiles;

  factory AppState.fromJson(JsonMap json) => AppState(
        locale: json['locale'] != null
            ? intl.Locale.parse(json['locale']).toFlutterLocale()
            : null,
        themeMode: ThemeMode.values[json['themeMode']],
        viewMode: ViewMode.values[json['viewMode']],
        showHiddenFiles: json['showHiddenFiles'],
      );

  JsonMap toJson() => {
        'locale': locale?.toLanguageTag(),
        'themeMode': themeMode.index,
        'viewMode': viewMode.index,
        'showHiddenFiles': showHiddenFiles,
      };

  AppState copyWith({
    // This is a function to allow for null values
    Locale? Function()? locale,
    ThemeMode? themeMode,
    ViewMode? viewMode,
    bool? showHiddenFiles,
  }) =>
      AppState(
        locale: locale != null ? locale() : this.locale,
        themeMode: themeMode ?? this.themeMode,
        viewMode: viewMode ?? this.viewMode,
        showHiddenFiles: showHiddenFiles ?? this.showHiddenFiles,
      );
}

extension LocaleEx on intl.Locale {
  /// Convert an [intl.Locale] into a [Locale]
  ///
  /// This is used with [intl.Locale.parse]
  Locale toFlutterLocale() => Locale.fromSubtags(
        languageCode: languageCode,
        countryCode: countryCode,
        scriptCode: scriptCode,
      );
}
