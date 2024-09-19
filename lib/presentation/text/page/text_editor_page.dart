import 'package:file_manager/app/router/route/text_editor_route_args.dart';
import 'package:file_manager/app/router/routes.dart';
import 'package:file_manager/app/widget/file_system_error_widget.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';

import '../bloc/text_editor_bloc.dart';
import 'text_editor_page_content.dart';

class TextEditorPage extends StatelessWidget {
  const TextEditorPage({
    super.key,
  });

  static RouteBase route = GoRoute(
    path: Routes.textEditor,
    builder: (context, state) {
      final args = state.extra as TextEditorRouteArgs;

      return BlocProvider(
        create: (context) => TextEditorBloc(path: args.path),
        child: const TextEditorPage(),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TextEditorBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(basename(bloc.path)),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: BlocConsumer<TextEditorBloc, TextEditorState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is TextEditorStateWriteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.message)),
            );
          }

          if (state is TextEditorStateWriteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.localizations.save_successful)),
            );
          }
        },
        buildWhen: (context, state) => state is TextEditorDataState,
        builder: (context, state) {
          if (state is TextEditorStateError) {
            return FileSystemErrorWidget(
              error: state.error,
              onRetry: () {
                bloc.add(TextEditorReadEvent());
              },
            );
          }

          if (state is TextEditorStateSuccess) {
            return TextEditorPageContent(
              content: state.content,
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
