abstract class TextEditorEvent {}

class TextEditorReadEvent extends TextEditorEvent {}

class TextEditorWriteEvent extends TextEditorEvent {
  final String content;

  TextEditorWriteEvent(this.content);
}
