import 'package:flutter/material.dart';

import '../style/snackbar_theme.dart';

final darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  snackBarTheme: snackBarTheme,
);