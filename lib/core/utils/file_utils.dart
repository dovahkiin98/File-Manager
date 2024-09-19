import 'dart:io';

import 'package:file_manager/core/i10n.dart';
import 'package:file_manager/data/model/file_size.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

String formatedModified({
  required BuildContext context,
  required FileSystemEntity entity,
}) {
  final stats = entity.statSync();
  final modified = stats.modified;

  final today = DateTime.now();

  if (modified.year == today.year) {
    return context
        .dateFormat(
          'MMM dd hh:mm a',
        )
        .format(modified);
  } else {
    return context
        .dateFormat(
          'MMM dd yyyy hh:mm a',
        )
        .format(modified);
  }
}

String fileType({
  required BuildContext context,
  required FileSystemEntity entity,
}) {
  if (entity is Directory) {
    return context.localizations.folder;
  } else {
    return '${extension(entity.path).substring(1).toUpperCase()} ${context.localizations.file}';
  }
}

IconData fileIcon(
  FileSystemEntity file,
) {
  final fileExtension = extension(file.path);

  if (imageExtensions.contains(fileExtension)) {
    return Icons.image_outlined;
  }

  if (videoExtensions.contains(fileExtension)) {
    return Icons.video_file_outlined;
  }

  if (audioExtensions.contains(fileExtension)) {
    return Icons.audio_file_outlined;
  }

  return switch (extension(file.path)) {
    '.pptx' ||
    '.ppt' ||
    '.csv' ||
    '.docs' ||
    '.doc' ||
    '.xlsx' ||
    '.xls' ||
    '.pdf' =>
      Icons.document_scanner_outlined,
    '.zip' || '.tar' || '.rar' => Icons.folder_zip_outlined,
    _ => Icons.insert_drive_file_outlined,
  };
}

String sizeText(
  FileSystemEntity file,
) {
  final fileSize = FileSize.forFile(file);

  return fileSize.toString();
}

final List<String> imageExtensions = [
  '.png',
  '.jpg',
  '.jpeg',
  '.ico',
  '.webp',
];

final List<String> videoExtensions = [
  '.mp4',
  '.mov',
  '.avi',
];

final List<String> audioExtensions = [
  '.mp3',
  '.m4a',
  '.ogg',
];
