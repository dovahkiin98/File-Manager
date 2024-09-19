import 'package:file_manager/app/router/fade_transition_page.dart';
import 'package:file_manager/app/router/route/folder_route_args.dart';
import 'package:file_manager/app/widget/file_system_error_widget.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:file_manager/core/utils/utils.dart';
import 'package:file_manager/data/model/filter_type.dart';
import 'package:file_manager/presentation/common/bloc/explorer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/folder_bloc.dart';
import '../../../app/widget/folder_permission_error.dart';
import 'folder_page_content.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({
    super.key,
    required this.path,
  });

  final String path;

  static String routeName = 'folder';

  static RouteBase route = GoRoute(
    path: '/',
    name: routeName,
    pageBuilder: (context, state) {
      final args = state.extra as FolderRouteArgs?;

      return FadeTransitionPage(
        key: state.pageKey,
        child: FolderPage(
          path: args?.path ?? defaultPath,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final explorerCubit = context.read<ExplorerCubit>();
    final bloc = explorerCubit.getFolderBloc(path: path);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: BlocConsumer<FolderBloc, FolderState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is FolderOperationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              state.error.message,
            )));
          }
        },
        buildWhen: (context, state) => state is FolderDataState,
        builder: (context, state) {
          if (state is FolderStatePermissionError) {
            return FolderPermissionError(
              onRetry: () {
                bloc.add(FolderCheckPermissionsEvent());
              },
            );
          }

          if (state is FolderStateError) {
            return FileSystemErrorWidget(
              error: state.error,
              onRetry: () {
                bloc.add(FolderGetFilesEvent());
              },
            );
          }

          if (state is FolderStateSuccess) {
            final files = state.files;

            if (files.isEmpty && bloc.filterType is FilterTypeAll) {
              return Center(
                child: Text(
                  context.localizations.no_files,
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }

            return BlocProvider.value(
              value: bloc,
              child: FolderPageContent(
                files: files,
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
