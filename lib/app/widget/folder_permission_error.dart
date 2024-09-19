import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';

class FolderPermissionError extends StatelessWidget {
  const FolderPermissionError({
    super.key,
    this.onRetry,
  });

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
            context.localizations.folder_permission_error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          if (onRetry != null)
            FilledButton(
              onPressed: onRetry,
              child: Text(context.localizations.request_permission),
            ),
        ],
      ),
    );
  }
}
