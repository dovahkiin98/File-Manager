import 'package:file/file.dart';

abstract class FolderState {}

class FolderStateInitial extends FolderState {}

abstract class FolderDataState extends FolderState {}

class FolderStatePermissionError extends FolderDataState {
  final bool isPermanent;

  FolderStatePermissionError({
    this.isPermanent = false,
  });
}

class FolderStateError extends FolderDataState {
  final FileSystemException error;

  FolderStateError(this.error);
}

class FolderStateSuccess extends FolderDataState {
  final List<FileSystemEntity> files;

  FolderStateSuccess(this.files);
}

class FolderOperationError extends FolderState {
  final FileSystemException error;

  FolderOperationError(this.error);
}
