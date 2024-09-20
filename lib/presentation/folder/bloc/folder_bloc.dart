import 'dart:async';

import 'package:collection/collection.dart';
import 'package:file/file.dart';
import 'package:file_manager/data/model/filter_type.dart';
import 'package:file_manager/data/model/sort_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'folder_event.dart';
import 'folder_state.dart';

export 'folder_event.dart';
export 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  FolderBloc({
    required Directory directory,
  })  : _directory = directory,
        super(FolderStateInitial()) {
    on<FolderCheckPermissionsEvent>(_onCheckPermissions);

    on<FolderGetFilesEvent>(_onGetFiles);

    on<FolderFilterChangedEvent>(_onFilterChanged);
    on<FolderSortChangedEvent>(_onSortChanged);

    on<FolderCreateEvent>(_onCreateFolder);
    on<FolderDeleteEvent>(_onDeleteFile);
    on<FolderRenameEvent>(_onRenameFile);

    try {
      // Watching will fail in `MemoryFileSystem`
      _fileEventStreamSubscription = _directory.watch().listen(_onFileEvent);
    } catch (_) {}
  }

  final Directory _directory;
  StreamSubscription? _fileEventStreamSubscription;

  FilterType _filterType = FilterTypeAll();

  FilterType get filterType => _filterType;

  SortType _sortType = SortTypeName();

  SortType get sortType => _sortType;

  SortOrder _sortOrder = SortOrder.asc;

  SortOrder get sortOrder => _sortOrder;

  FutureOr<void> _onCheckPermissions(
    FolderCheckPermissionsEvent event,
    Emitter<FolderState> emit,
  ) async {
    emit(FolderStateInitial());

    var permissions = await [
      Permission.manageExternalStorage,
      Permission.storage,
    ].request();

    if (permissions.containsValue(PermissionStatus.granted)) {
      add(FolderGetFilesEvent());
    } else {
      emit(FolderStatePermissionError(
        isPermanent:
            permissions.containsValue(PermissionStatus.permanentlyDenied),
      ));
    }
  }

  FutureOr<void> _onGetFiles(
    FolderGetFilesEvent event,
    Emitter<FolderState> emit,
  ) async {
    try {
      final entities = await _directory.list().toList();

      Iterable<FileSystemEntity> files = entities.whereNot((e) {
        return e is Link || path.basename(e.path).startsWith('.');
      });

      files = _filterType.apply(files);
      files = _sortType.apply(files, order: sortOrder);

      emit(FolderStateSuccess(files.toList(
        growable: false,
      )));
    } on FileSystemException catch (e) {
      emit(FolderStateError(e));
    }
  }

  FutureOr<void> _onFilterChanged(
    FolderFilterChangedEvent event,
    Emitter<FolderState> emit,
  ) async {
    if (event.filter == _filterType) {
      return;
    }

    _filterType = event.filter;

    add(FolderGetFilesEvent());
  }

  FutureOr<void> _onSortChanged(
    FolderSortChangedEvent event,
    Emitter<FolderState> emit,
  ) async {
    if (event.sort == _sortType && event.order == _sortOrder) {
      return;
    }

    _sortType = event.sort;
    _sortOrder = event.order;

    add(FolderGetFilesEvent());
  }

  @override
  Future<void> close() {
    _fileEventStreamSubscription?.cancel();
    return super.close();
  }

  void _onFileEvent(FileSystemEvent event) {
    add(FolderGetFilesEvent());
  }

  FutureOr<void> _onCreateFolder(
    FolderCreateEvent event,
    Emitter<FolderState> emit,
  ) async {
    try {
      if (path.extension(event.name).isNotEmpty) {
        final newFile = _directory.childFile(event.name);

        await newFile.create();
      } else {
        final newFile = _directory.childDirectory(event.name);

        await newFile.create();
      }
    } on FileSystemException catch (e) {
      emit(FolderOperationError(e));
    }
  }

  FutureOr<void> _onDeleteFile(
    FolderDeleteEvent event,
    Emitter<FolderState> emit,
  ) async {
    try {
      await event.file.delete();
    } on FileSystemException catch (e) {
      emit(FolderOperationError(e));
    }
  }

  FutureOr<void> _onRenameFile(
    FolderRenameEvent event,
    Emitter<FolderState> emit,
  ) async {
    try {
      final directoryPath = path.dirname(event.file.path);

      await event.file.rename(path.join(
        directoryPath,
        event.name,
      ));
    } on FileSystemException catch (e) {
      emit(FolderOperationError(e));
    }
  }
}
