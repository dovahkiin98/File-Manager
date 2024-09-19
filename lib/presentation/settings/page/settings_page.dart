import 'package:file_manager/app/bloc/app_cubit/app_cubit.dart';
import 'package:file_manager/app/router/routes.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widget/settings_locale_sheet.dart';
import '../widget/settings_night_mode_sheet.dart';
import '../widget/settings_utils.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static RouteBase route = GoRoute(
    path: Routes.settings,
    builder: (context, state) => const SettingsPage(),
  );

  @override
  Widget build(BuildContext context) {
    final appCubit = context.watch<AppCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations.settings),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Builder(builder: (context) {
        final padding = MediaQuery.paddingOf(context);

        return ListView(
          padding: padding +
              const EdgeInsets.symmetric(
                vertical: 16,
              ),
          children: [
            ListTile(
              onTap: () {
                SettingsNightModeSheet.showAsModalBottomSheet(context)
                    .then((value) {
                  if (value != null) {
                    appCubit.setThemeMode(value);
                  }
                });
              },
              title: Text(context.localizations.night_mode),
              subtitle: Text(context.localizations.night_mode_subtitle),
              trailing: Text(
                context.themeModeName(appCubit.state.themeMode),
              ),
            ),
            ListTile(
              onTap: () {
                SettingsLocaleSheet.showAsModalBottomSheet(context)
                    .then((value) {
                  if (value != null) {
                    if (value == AppCubit.systemLocale) {
                      appCubit.setLocale(null);
                    } else {
                      appCubit.setLocale(value);
                    }
                  }
                });
              },
              title: Text(context.localizations.language),
              subtitle: Text(
                context.localizations.language_subtitle,
              ),
              trailing: Text(
                context.getLocaleName(appCubit.state.locale),
              ),
            ),
            SwitchListTile(
              value: appCubit.state.showHiddenFiles,
              title: Text(context.localizations.show_hidden_files),
              subtitle: Text(
                context.localizations.show_hidden_files_subtitle,
              ),
              onChanged: (value) {
                appCubit.setShowHiddenFiles(value);
              },
            ),
          ],
        );
      }),
    );
  }
}
