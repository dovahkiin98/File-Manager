import 'package:file_manager/app/router/routes.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:file_manager/core/utils/utils.dart';
import 'package:file_manager/presentation/common/bloc/explorer_cubit.dart';
import 'package:file_manager/presentation/folder/bloc/folder_bloc.dart';
import 'package:file_manager/presentation/folder/page/folder_page.dart';
import 'package:file_manager/presentation/folder/widget/dialog/input_name_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' show basename;

import '../mixin/explorer_history.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({
    required this.child,
    super.key,
  });

  final Widget child;

  static RouteBase route = ShellRoute(
    routes: [
      FolderPage.route,
    ],
    builder: (context, state, child) => BlocProvider(
      create: (context) => ExplorerCubit(
        repository: context.read(),
      ),
      child: ExplorerPage(
        child: child,
      ),
    ),
  );

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> with ExplorerHistory {
  ExplorerCubit get explorerCubit => context.read();

  FolderBloc get currentBloc => explorerCubit.getFolderBloc(
        path: currentPath,
      );

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          title: Text(
            currentPath == defaultPath
                ? context.localizations.internal_storage
                : basename(currentPath),
          ),
          titleSpacing: 0,
          leading: history.length > 1
              ? IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                )
              : IconButton(
                  onPressed: () {
                    context.push(Routes.settings);
                  },
                  icon: const Icon(Icons.settings),
                  tooltip: context.localizations.settings,
                ),
          // bottom: history.length > 1
          //     ? PreferredSize(
          //         preferredSize: const Size.fromHeight(40),
          //         child: Text(''),
          //       )
          //     : null,
          actions: [
            IconButton(
              onPressed: () {
                context.push(Routes.search);
              },
              icon: const Icon(Icons.search),
              tooltip: context.localizations.search,
            ),
          ],
        ),
        body: widget.child,
        floatingActionButton: FloatingActionButton(
          onPressed: _onFloatingActionButtonClick,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _onFloatingActionButtonClick() async {
    final name = await InputNameDialog.showAsDialog(
      context,
      title: context.localizations.create_folder,
      hint: context.localizations.folder_name,
      path: currentPath,
    );

    if (name != null) {
      currentBloc.add(FolderCreateEvent(name: name));
    }
  }
}
