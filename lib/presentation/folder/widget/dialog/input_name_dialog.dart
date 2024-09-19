import 'dart:io';

import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;

class InputNameDialog extends StatefulWidget {
  const InputNameDialog({
    super.key,
    required this.title,
    required this.hint,
    required this.path,
    this.initialName,
  });

  final String title;
  final String hint;
  final String path;
  final String? initialName;

  static Future<String?> showAsDialog(
    BuildContext context, {
    required String title,
    required String hint,
    required String path,
    String? initialName,
  }) =>
      showDialog(
        context: context,
        builder: (context) => InputNameDialog(
          title: title,
          hint: hint,
          path: path,
          initialName: initialName,
        ),
      );

  @override
  State<InputNameDialog> createState() => _InputNameDialogState();

  static const String reservedChars = "|\\?*<\":>+[]/'";
}

class _InputNameDialogState extends State<InputNameDialog> {
  final TextEditingController controller = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    controller.text = widget.initialName ?? '';
    textFieldFocusNode.requestFocus();

    if (widget.initialName != null) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: path.basenameWithoutExtension(widget.initialName!).length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = errorText();

    return AlertDialog(
      title: Text(widget.title),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(context.localizations.cancel),
        ),
        TextButton(
          onPressed: controller.text.trim().isNotEmpty && error == null
              ? () {
                  Navigator.of(context).pop(controller.text.trim());
                }
              : null,
          child: widget.initialName == null
              ? Text(context.localizations.create)
              : Text(context.localizations.rename),
        ),
      ],
      content: SizedBox(
        width: 480,
        child: TextField(
          controller: controller,
          focusNode: textFieldFocusNode,
          onChanged: (value) {
            setState(() {});
          },
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.of(context).pop(value.trim());
            }
          },
          textCapitalization: TextCapitalization.sentences,
          autocorrect: false,
          enableSuggestions: false,

          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: error,
          ),
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
    );
  }

  String? errorText() {
    final input = controller.text.trim();
    final name = path.withoutExtension(input).trim();
    final extension = path.extension(input);

    final fullName = name + extension;

    try {
      if (fullName.isEmpty) {
        return null;
      }

      for (var e in InputNameDialog.reservedChars.characters) {
        if (fullName.contains(e)) {
          return context.localizations.invalid_name;
        }
      }

      final filePath = path.join(
        widget.path,
        fullName,
      );

      final directory = Directory(filePath);
      final file = File(filePath);

      if (directory.existsSync() || file.existsSync()) {
        return context.localizations.folder_exists;
      }

      return null;
    } on FileSystemException catch (e) {
      return e.message;
    }
  }
}
