import 'dart:io';

typedef JsonMap = Map<String, dynamic>;


String get defaultPath {
  if (Platform.isAndroid) {
    return '/storage/emulated/0/';
  } else {
    return '/';
  }
}