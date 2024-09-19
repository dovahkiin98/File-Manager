import 'package:file/file.dart';
import 'package:file_manager/core/i10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' hide context;

import '../bloc/folder_bloc.dart';
import '../widget/dialog/delete_file_dialog.dart';
import '../widget/dialog/file_info_dialog.dart';
import '../widget/dialog/input_name_dialog.dart';
import '../widget/file_popup_menu.dart';

mixin FilePopupHandler<T extends StatefulWidget> on State<T> {
  void onFilePopupSelected({
    required FileSystemEntity file,
    required FilePopupResult result,
  }) {
    switch (result) {
      case FilePopupResult.delete:
        onDelete(file);
      case FilePopupResult.rename:
        onRename(file);
      case FilePopupResult.info:
        onInfo(file);
    }
  }

  void onDelete(FileSystemEntity file) async {
    final bloc = context.read<FolderBloc>();

    final dialogResult = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteFileDialog(file: file),
    );

    if (dialogResult == true) {
      bloc.add(FolderDeleteEvent(file: file));
    }
  }

  void onRename(FileSystemEntity file) async {
    final bloc = context.read<FolderBloc>();

    final dialogResult = await InputNameDialog.showAsDialog(
      context,
      title: context.localizations.rename,
      hint: context.localizations.folder_name,
      path: dirname(file.path),
      initialName: basename(file.path),
    );

    if (dialogResult != null) {
      bloc.add(FolderRenameEvent(
        file: file,
        name: dialogResult,
      ));
    }
  }

  void onInfo(FileSystemEntity file) {
    showDialog(
      context: context,
      builder: (context) => FileInfoDialog(file: file),
    );
  }
}
