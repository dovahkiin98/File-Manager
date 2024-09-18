import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'folder_event.dart';
import 'folder_state.dart';

export 'folder_event.dart';
export 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  FolderBloc({
    required this.path,
  }) : super(FolderStateInitial()) {
    on<FolderCheckPermissionsEvent>(_onCheckPermissions);

    add(FolderCheckPermissionsEvent());
  }

  final String path;

  FutureOr<void> _onCheckPermissions(
    FolderCheckPermissionsEvent event,
    Emitter<FolderState> emit,
  ) async {

  }
}
