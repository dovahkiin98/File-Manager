import 'package:file/file.dart';
import 'package:mime/mime.dart';

extension FileSystemEntityEx on FileSystemEntity {
  bool isImage() {
    return mimeType?.startsWith('image/') == true;
  }

  bool isVideo() {
    return mimeType?.startsWith('video/') == true;
  }

  bool isAudio() {
    return mimeType?.startsWith('audio/') == true;
  }

  String? get mimeType => lookupMimeType(path);
}
