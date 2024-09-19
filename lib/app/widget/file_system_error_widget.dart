import 'dart:io';

import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';

class FileSystemErrorWidget extends StatelessWidget {
  const FileSystemErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  final FileSystemException error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error.osError?.message ?? error.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          if (onRetry != null)
            FilledButton(
              onPressed: onRetry,
              child: Text(context.localizations.retry),
            ),
        ],
      ),
    );
  }
}