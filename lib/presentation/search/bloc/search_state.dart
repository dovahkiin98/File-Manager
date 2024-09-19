import 'package:file/file.dart';

abstract class SearchState {}

class SearchStateInitial extends SearchState {}

class SearchStateLoading extends SearchState {}

abstract class FolderDataState extends SearchState {}

class SearchStatePermissionError extends FolderDataState {
  final bool isPermanent;

  SearchStatePermissionError({
    this.isPermanent = false,
  });
}

class SearchStateError extends FolderDataState {
  final FileSystemException error;

  SearchStateError(this.error);
}

class SearchStateSuccess extends FolderDataState {
  final List<FileSystemEntity> files;

  SearchStateSuccess(this.files);
}