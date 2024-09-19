import 'package:file_manager/core/utils/extension/widget_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../bloc/text_editor_bloc.dart';

class TextEditorPageContent extends StatefulWidget {
  const TextEditorPageContent({
    super.key,
    required this.content,
  });

  final String content;

  @override
  State<TextEditorPageContent> createState() => _TextEditorPageContentState();
}

class _TextEditorPageContentState extends State<TextEditorPageContent> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController(
      text: widget.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TextEditorBloc>();
    final padding = MediaQuery.paddingOf(context);

    return ScaffoldMessenger(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: padding +
              const EdgeInsets.all(16) +
              const EdgeInsets.only(bottom: 72),
          child: TextField(
            controller: textEditingController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              filled: false,
              border: InputBorder.none,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.clearFocus(hideKeyboard: true);

            bloc.add(TextEditorWriteEvent(textEditingController.text));
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
