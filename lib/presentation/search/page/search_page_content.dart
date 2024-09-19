import 'package:file/file.dart';
import 'package:file_manager/app/router/route/text_editor_route_args.dart';
import 'package:file_manager/app/router/routes.dart';
import 'package:file_manager/presentation/folder/widget/list/file_list_item.dart';
import 'package:file_manager/presentation/folder/widget/list/folder_list_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class SearchPageContent extends StatefulWidget {
  const SearchPageContent({
    super.key,
    required this.files,
  });

  final List<FileSystemEntity> files;

  @override
  State<SearchPageContent> createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<SearchPageContent> {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return AnimatedList(
      key: GlobalKey<AnimatedListState>(),
      padding: padding +
          const EdgeInsets.symmetric(
            vertical: 16,
          ),
      initialItemCount: widget.files.length,
      itemBuilder: (context, i, animation) {
        final file = widget.files[i];

        if (file is Directory) {
          return FolderListItem(
            directory: file,
            // onTap: (directory) {
            //   widget.clearFocus();
            //   context.pushNamed(
            //     FolderPage.routeName,
            //     extra: FolderRouteArgs(
            //       path: directory.path,
            //     ),
            //   );
            // },
            // onPopupSelected: (result) {
            //   onFilePopupSelected(
            //     file: file,
            //     result: result,
            //   );
            // },
          );
        } else if (file is File) {
          return FileListItem(
            file: file,
            onTap: onOpenFile,
            // onPopupSelected: (result) {
            //   onFilePopupSelected(
            //     file: file,
            //     result: result,
            //   );
            // },
          );
        }

        return const SizedBox();
      },
    );
  }

  void onOpenFile(File file) {
    final fileExtension = path.extension(file.path);

    if (fileExtension == '.txt') {
      context.push(
        Routes.textEditor,
        extra: TextEditorRouteArgs(path: file.path),
      );
    } else {
      OpenFile.open(file.path);
    }
  }
}
