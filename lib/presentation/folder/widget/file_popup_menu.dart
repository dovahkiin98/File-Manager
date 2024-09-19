import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';

class FilePopupMenu extends StatelessWidget {
  const FilePopupMenu({super.key,
    this.onSelected,});

  final Function(FilePopupResult)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FilePopupResult>(
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          value: FilePopupResult.rename,
          child: Text(context.localizations.rename),
        ),
        PopupMenuItem(
          value: FilePopupResult.delete,
          child: Text(context.localizations.delete),
        ),
        PopupMenuItem(
          value: FilePopupResult.info,
          child: Text(context.localizations.details),
        ),
      ],
      onSelected:onSelected,
      menuPadding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      constraints: const BoxConstraints(
        minWidth: 180,
      ),
      surfaceTintColor: Theme.of(context).colorScheme.onSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}

enum FilePopupResult {
  delete,
  rename,
  info,
  ;
}