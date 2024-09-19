import 'package:file_manager/data/repository.dart';
import 'package:file_manager/presentation/folder/bloc/folder_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This is created as a Cubit as it doesn't require any events
/// So it would make more sense to be just a Cubit instead of an entire BLoC
class ExplorerCubit extends Cubit {
  ExplorerCubit({
    required Repository repository,
  })  : _repository = repository,
        super(null);

  final Repository _repository;

  final Map<String, FolderBloc> _folders = {};

  FolderBloc getFolderBloc({
    required String path,
  }) {
    // If the BLoC doesn't exist, create a new one
    if (_folders[path] == null) {
      _folders[path] = FolderBloc(
        directory: _repository.fileSystem.directory(path),
      )..add(FolderCheckPermissionsEvent());
    }

    return _folders[path]!;
  }

  void removeFolderBloc({
    required String path,
  }) {
    _folders[path]?.close();
    _folders.remove(path);
  }

  void _disposeAllBlocs() {
    _folders.forEach((key, bloc) => bloc.close());
    _folders.clear();
  }

  @override
  Future<void> close() {
    _disposeAllBlocs();
    return super.close();
  }
}
