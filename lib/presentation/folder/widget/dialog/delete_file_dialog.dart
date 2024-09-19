import 'dart:io';

import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';

class DeleteFileDialog extends StatelessWidget {
  const DeleteFileDialog({
    super.key,
    required this.file,
  });

  final FileSystemEntity file;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text.rich(TextSpan(children: [
        TextSpan(text: context.localizations.delete),
        const TextSpan(text: ' '),
        TextSpan(
          text: basename(file.path),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ])),
      content: Text.rich(TextSpan(children: [
        TextSpan(text: context.localizations.delete_file_content),
        const TextSpan(text: ' '),
        TextSpan(
          text: basename(file.path),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const TextSpan(text: '?'),
      ])),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(context.localizations.no),
        ),
        TextButton(
          onPressed: () {
            context.pop(true);
          },
          child: Text(context.localizations.yes),
        ),
      ],
    );
  }
}
