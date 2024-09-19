import 'package:file_manager/app/bloc/app_cubit/app_cubit.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:file_manager/presentation/settings/widget/settings_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsNightModeSheet extends StatelessWidget {
  const SettingsNightModeSheet({super.key});

  static Future<ThemeMode?> showAsModalBottomSheet(
    BuildContext context,
  ) =>
      showModalBottomSheet<ThemeMode>(
        context: context,
        constraints: const BoxConstraints(
          maxHeight: 300,
        ),
        builder: (context) => const SettingsNightModeSheet(),
      );

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select(
      (AppCubit cubit) => cubit.state.themeMode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          child: Text(
            context.localizations.night_mode,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ...ThemeMode.values.map(
                (e) => RadioListTile(
                  value: e,
                  groupValue: themeMode,
                  title: Text(context.themeModeName(e)),
                  toggleable: true,
                  onChanged: (value) {
                    GoRouter.of(context).pop(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
