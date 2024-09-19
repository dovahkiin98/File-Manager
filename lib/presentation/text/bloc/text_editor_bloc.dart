import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import 'text_editor_event.dart';
import 'text_editor_state.dart';

export 'text_editor_event.dart';
export 'text_editor_state.dart';

class TextEditorBloc extends Bloc<TextEditorEvent, TextEditorState> {
  TextEditorBloc({
    required this.path,
  }) : super(TextEditorStateInitial()) {
    assert(
      extension(path) == '.txt',
      'Only TXT files can be opened',
    );

    on<TextEditorReadEvent>(_onRead);
    on<TextEditorWriteEvent>(_onWrite);

    add(TextEditorReadEvent());
  }

  final String path;

  FutureOr<void> _onRead(
    TextEditorReadEvent event,
    Emitter<TextEditorState> emit,
  ) async {
    try {
      final content = await File(path).readAsString();

      emit(TextEditorStateSuccess(content));
    } on FileSystemException catch (e) {
      emit(TextEditorStateError(e));
    }
  }

  FutureOr<void> _onWrite(
    TextEditorWriteEvent event,
    Emitter<TextEditorState> emit,
  ) async {
    try {
      await File(path).writeAsString(event.content);

      emit(TextEditorStateWriteSuccess());
    } on FileSystemException catch (e) {
      emit(TextEditorStateWriteError(e));
    }
  }
}
