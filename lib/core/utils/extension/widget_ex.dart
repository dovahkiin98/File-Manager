import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension WidgetEx on Widget {
  void clearFocus({
    bool hideKeyboard = false,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (hideKeyboard) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }
}