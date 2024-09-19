import 'package:file/file.dart';
import 'package:file_manager/core/utils/file_utils.dart';
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
        return imageExtensions.contains(extension(e.path));
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
