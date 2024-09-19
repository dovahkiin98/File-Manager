import 'package:collection/collection.dart';
import 'package:file/file.dart';
import 'package:path/path.dart';

sealed class SortType {
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files, {
    SortOrder order = SortOrder.asc,
  });

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType;
  }
}

class SortTypeName extends SortType {
  @override
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files, {
    SortOrder order = SortOrder.asc,
  }) =>
      files.sorted((a, b) {
        // TODO Find a way to not repeat this in every subclass
        if (a.runtimeType != b.runtimeType) {
          return a is Directory ? -1 : 1;
        }

        return basename(a.path).compareTo(basename(b.path)) * order.value;
      });
}

class SortTypeSize extends SortType {
  @override
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files, {
    SortOrder order = SortOrder.asc,
  }) =>
      files.sorted((a, b) {
        if (a.runtimeType != b.runtimeType) {
          return a is Directory ? -1 : 1;
        }

        final aStats = a.statSync();
        final bStats = b.statSync();

        return aStats.size.compareTo(bStats.size) * order.value;
      });
}

class SortTypeDateModified extends SortType {
  @override
  Iterable<FileSystemEntity> apply(
    Iterable<FileSystemEntity> files, {
    SortOrder order = SortOrder.asc,
  }) =>
      files.sorted((a, b) {
        if (a.runtimeType != b.runtimeType) {
          return a is Directory ? -1 : 1;
        }

        final aStats = a.statSync();
        final bStats = b.statSync();

        return aStats.modified.compareTo(bStats.modified) * order.value;
      });
}

enum SortOrder {
  asc(1),
  desc(-2),
  ;

  const SortOrder(this.value);

  final int value;

  SortOrder flip() => switch (this) {
        asc => desc,
        desc => asc,
      };
}
