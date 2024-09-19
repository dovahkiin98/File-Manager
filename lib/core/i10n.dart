import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension AppLocalizationsX on BuildContext {
  AppLocalizations get localizations => AppLocalizations.of(this)!;

  DateFormat dateFormat(
    String? pattern, {
    bool? useNativeDigits = true,
  }) {
    final isArabic = localizations.localeName.contains('ar');

    if (pattern != null) {
      pattern = isArabic ? pattern.replaceAll(',', '،') : pattern;
    }

    final dateFormat = DateFormat(
      pattern,
      localizations.localeName,
    );

    if (useNativeDigits != null) {
      dateFormat.useNativeDigits = useNativeDigits;
    }

    return dateFormat;
  }

  String formattedTimeAgo(DateTime date) => timeago.format(
        date,
        locale: localizations.localeName,
      );
}

extension StateLocalizationsEx on State {
  AppLocalizations get localizations => context.localizations;
}
