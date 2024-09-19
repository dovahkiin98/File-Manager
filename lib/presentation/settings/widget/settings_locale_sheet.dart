import 'package:file_manager/app/bloc/app_cubit/app_cubit.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:file_manager/presentation/settings/widget/settings_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsLocaleSheet extends StatelessWidget {
  const SettingsLocaleSheet({
    super.key,
  });

  static Future<Locale?> showAsModalBottomSheet(
    BuildContext context,
  ) =>
      showModalBottomSheet<Locale>(
        context: context,
        constraints: const BoxConstraints(
          maxHeight: 300,
        ),
        builder: (context) => const SettingsLocaleSheet(),
      );

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);

    final selectedLocale = context.select(
      (AppCubit cubit) => cubit.state.locale ?? AppCubit.systemLocale,
    );

    final locales =
        context.findAncestorWidgetOfExactType<MaterialApp>()!.supportedLocales;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          child: Text(
            context.localizations.language,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: padding +
                const EdgeInsets.only(
                  bottom: 16,
                ),
            children: [
              ...[AppCubit.systemLocale, ...locales].map(
                (e) => RadioListTile(
                  value: e,
                  groupValue: selectedLocale,
                  toggleable: true,
                  title: Text(
                    context.getLocaleName(e),
                  ),
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
