import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_cubit/app_cubit.dart';
import 'router/router.dart';
import 'theme/dark/dark_theme.dart';
import 'theme/light/light_theme.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.select(
      (AppCubit cubit) => cubit.locale,
    );

    final themeMode = context.select(
      (AppCubit cubit) => cubit.state.themeMode,
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'File Manager',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: themeMode,
      locale: locale,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
