import 'package:file_manager/app/router/fade_transition_page.dart';
import 'package:file_manager/app/router/routes.dart';
import 'package:file_manager/app/widget/file_system_error_widget.dart';
import 'package:file_manager/app/widget/folder_permission_error.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:file_manager/core/utils/extension/widget_ex.dart';
import 'package:file_manager/core/utils/utils.dart';
import 'package:file_manager/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/search_bloc.dart';
import 'search_page_content.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
    // required this.path,
  });

  // final String path;

  static RouteBase route = GoRoute(
    path: Routes.search,
    pageBuilder: (context, state) {
      final repository = context.read<Repository>();
      final directory = repository.fileSystem.directory(defaultPath);

      return FadeTransitionPage(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) => SearchBloc(directory: directory)
            ..add(SearchCheckPermissionsEvent()),
          child: const SearchPage(
              // path: args?.path ?? defaultPath,
              ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: TextField(
          onChanged: (value) {
            bloc.add(SearchApplySearchEvent(value));
          },
          onSubmitted: (value) {
            bloc.add(SearchApplySearchEvent(value));
            clearFocus();
          },
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '${context.localizations.search}...',
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is SearchStatePermissionError) {
            return FolderPermissionError(
              onRetry: () {
                bloc.add(SearchCheckPermissionsEvent());
              },
            );
          }

          if (state is SearchStateError) {
            return FileSystemErrorWidget(
              error: state.error,
              onRetry: () {
                bloc.add(SearchRetryEvent());
              },
            );
          }

          if (state is SearchStateSuccess) {
            final files = state.files;

            if (files.isEmpty) {
              return Center(
                child: Text(
                  context.localizations.no_files,
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }

            return BlocProvider.value(
              value: bloc,
              child: SearchPageContent(
                files: files,
              ),
            );
          }

          if (state is SearchStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
