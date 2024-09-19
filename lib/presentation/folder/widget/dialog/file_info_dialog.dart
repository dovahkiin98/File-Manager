import 'dart:io';

import 'package:file_manager/core/i10n.dart';
import 'package:file_manager/core/utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FileInfoDialog extends StatelessWidget {
  const FileInfoDialog({
    super.key,
    required this.file,
  });

  final FileSystemEntity file;

  @override
  Widget build(BuildContext context) {
    final stats = file.statSync();

    return SimpleDialog(
      title: Text(context.localizations.details),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      contentPadding: const EdgeInsets.all(24),
      children: [
        Text(
          context.localizations.name,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ),
        Text(
          basename(file.path),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.localizations.type,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ),
        Text(
          fileType(
            context: context,
            entity: file,
          ),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.localizations.size,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ),
        Text(
          sizeText(file),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.localizations.last_modified,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ),
        Text(
          context.dateFormat('MMM dd, yyyy hh:mm a').format(stats.modified),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.localizations.path,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ),
        Text(
          file.path,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
