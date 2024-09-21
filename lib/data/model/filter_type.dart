import 'package:file/file.dart';
import 'package:file_manager/core/utils/extension/file_system_entity_ex.dart';
import 'package:path/path.dart';

sealed class FilterType {
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files,
  );

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType;
  }
}

class FilterTypeAll extends FilterType {
  @override
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files,
  ) =>
      files;
}

class FilterTypeFolders extends FilterType {
  @override
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files,
  ) =>
      files.whereType<Directory>();
}

class FilterTypeFiles extends FilterType {
  @override
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files,
  ) =>
      files.whereType<File>();
}

class FilterTypeImages extends FilterType {
  @override
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files,
  ) =>
      files.where((e) {
        return e.isImage();
      });
}

class FilterTypeText extends FilterType {
  @override
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files,
  ) =>
      files.where((e) {
        return extension(e.path) == 'txt';
      });
}
