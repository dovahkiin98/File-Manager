import 'package:file/file.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:file_manager/core/utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../file_popup_menu.dart';

class FolderListItem extends StatelessWidget {
  const FolderListItem({
    required this.directory,
    this.onTap,
    this.selected = false,
    this.onPopupSelected,
    super.key,
  });

  final Directory directory;
  final bool selected;
  final Function(Directory)? onTap;
  final Function(FilePopupResult)? onPopupSelected;

  @override
  Widget build(BuildContext context) {
    final stats = directory.statSync();
    final items = getItems();

    return ListTile(
      leading: const SizedBox.square(
        dimension: 48,
        child: Icon(Icons.folder_outlined),
      ),
      minLeadingWidth: 48,
      title: Text(
        basename(directory.path),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              formatedModified(
                context: context,
                entity: directory,
              ),
            ),
          ),
          Text(
            '${items.length} ${context.localizations.items.toLowerCase()}',
          ),
        ],
      ),
      trailing: onPopupSelected != null
          ? FilePopupMenu(
              onSelected: onPopupSelected,
            )
          : null,
      contentPadding: EdgeInsetsDirectional.only(
        start: 8,
        end: onPopupSelected != null ? 8 : 16,
      ),
      onTap: onTap != null
          ? () {
              onTap!(directory);
            }
          : null,
    );
  }

  List<FileSystemEntity> getItems() {
    try {
      final items = directory.listSync();

      return items;
    } on FileSystemException catch (e) {
      return [];
    }
  }
}
