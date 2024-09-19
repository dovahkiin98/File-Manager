import 'package:file/file.dart';
import 'package:file_manager/data/model/filter_type.dart';
import 'package:file_manager/data/model/sort_type.dart';

abstract class FolderEvent {}

class FolderCheckPermissionsEvent extends FolderEvent {}

class FolderGetFilesEvent extends FolderEvent {}

class FolderFilterChangedEvent extends FolderEvent {
  final FilterType filter;

  FolderFilterChangedEvent(this.filter);
}

class FolderSortChangedEvent extends FolderEvent {
  final SortType sort;
  final SortOrder order;

  FolderSortChangedEvent({
    required this.sort,
    required this.order,
  });
}

class FolderCreateEvent extends FolderEvent {
  final String name;

  FolderCreateEvent({
    required this.name,
  });
}

class FolderRenameEvent extends FolderEvent {
  final String name;
  final FileSystemEntity file;

  FolderRenameEvent({
    required this.file,
    required this.name,
  });
}

class FolderDeleteEvent extends FolderEvent {
  final FileSystemEntity file;

  FolderDeleteEvent({
    required this.file,
  });
}
