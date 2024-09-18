import 'dart:ui';

import 'package:file_manager/core/utils/utils.dart';
import 'package:file_manager/data/model/view_mode.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app_state.dart';

///
/// This is a [HydratedCubit]. It utilizes Hive to save data and restore it using
/// [fromJson] and [toJson]
///
/// This is used to save app preferences such as :
/// - Locale
/// - Theme Mode
/// - View Mode
class AppCubit extends HydratedCubit<AppState> {
  AppCubit()
      : super(
          AppState(
            themeMode: ThemeMode.system,
            viewMode: ViewMode.list,
          ),
        );

  Locale get locale => state.locale ?? PlatformDispatcher.instance.locale;

  void setViewMode(ViewMode viewMode) {
    emit(state.copyWith(viewMode: viewMode));
  }

  void setThemeMode(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
  }

  void setLocale(Locale? locale) {
    emit(state.copyWith(locale: () => locale));
  }

  /// This is marked `Visible For Testing` to show a warning
  /// to warn you from using it in production
  @visibleForTesting
  void toggleLocale() {
    final currentLocale = state.locale;
    final newLocale = currentLocale?.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');

    emit(state.copyWith(locale: () => newLocale));
  }

  /// This is marked `Visible For Testing` to show a warning
  /// to warn you from using it in production
  @visibleForTesting
  void toggleThemeMode() {
    final currentTheme = state.themeMode;
    final newTheme =
        currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    emit(state.copyWith(themeMode: newTheme));
  }

  @override
  AppState? fromJson(JsonMap json) => AppState.fromJson(json);

  @override
  JsonMap? toJson(AppState state) => state.toJson();
}
