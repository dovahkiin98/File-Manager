import 'package:flutter/material.dart';

import '../style/snackbar_theme.dart';

final lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  snackBarTheme: snackBarTheme,
);