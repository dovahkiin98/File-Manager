import 'package:file/file.dart';

abstract class TextEditorState {}

abstract class TextEditorDataState extends TextEditorState {}

class TextEditorStateInitial extends TextEditorDataState {}

class TextEditorStateSuccess extends TextEditorDataState {
  final String content;

  TextEditorStateSuccess(this.content);
}

class TextEditorStateError extends TextEditorDataState {
  final FileSystemException error;

  TextEditorStateError(this.error);
}

class TextEditorStateWriteError extends TextEditorState {
  final FileSystemException error;

  TextEditorStateWriteError(this.error);
}

class TextEditorStateWriteSuccess extends TextEditorState {}
