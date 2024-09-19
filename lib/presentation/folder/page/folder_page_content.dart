
import 'package:file/file.dart';
import 'package:file_manager/app/router/route/folder_route_args.dart';
import 'package:file_manager/app/router/route/text_editor_route_args.dart';
import 'package:file_manager/app/router/routes.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

import '../bloc/folder_bloc.dart';
import '../mixin/file_popup_handler.dart';
import '../widget/folder_page_menu.dart';
import '../widget/list/file_list_item.dart';
import '../widget/list/folder_list_item.dart';
import 'folder_page.dart';

class FolderPageContent extends StatefulWidget {
  const FolderPageContent({
    super.key,
    required this.files,
  });

  final List<FileSystemEntity> files;

  @override
  State<FolderPageContent> createState() => _FolderPageContentState();
}

class _FolderPageContentState extends State<FolderPageContent>
    with FilePopupHandler {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FolderBloc>();

    final files = widget.files;
    final padding = MediaQuery.paddingOf(context);

    final hasFloatingActionButton =
        Scaffold.of(context).hasFloatingActionButton;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FolderPageMenu(
            filterType: bloc.filterType,
            sortType: bloc.sortType,
            sortOrder: bloc.sortOrder,
            onFilterChanged: (filter) {
              if (filter == null) {
                return;
              }

              bloc.add(FolderFilterChangedEvent(filter));
            },
            onSortChanged: (sort, order) {
              if (sort == null) {
                return;
              }

              bloc.add(FolderSortChangedEvent(
                sort: sort,
                order: order,
              ));
            },
          ),
        ),
        if (files.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(
                context.localizations.no_files,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        SliverPadding(
          padding: padding +
              const EdgeInsets.symmetric(
                vertical: 16,
              ) +
              (hasFloatingActionButton
                  ? const EdgeInsets.only(bottom: 72)
                  : EdgeInsets.zero),
          sliver: SliverAnimatedList(
            key: GlobalKey<AnimatedListState>(),
            initialItemCount: files.length,
            itemBuilder: (context, i, animation) {
              final file = files[i];

              if (file is Directory) {
                return FolderListItem(
                  directory: file,
                  onTap: (directory) {
                    context.pushNamed(
                      FolderPage.routeName,
                      extra: FolderRouteArgs(
                        path: directory.path,
                      ),
                    );
                  },
                  onPopupSelected: (result) {
                    onFilePopupSelected(
                      file: file,
                      result: result,
                    );
                  },
                );
              } else if (file is File) {
                return FileListItem(
                  file: file,
                  onTap: onOpenFile,
                  onPopupSelected: (result) {
                    onFilePopupSelected(
                      file: file,
                      result: result,
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
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
