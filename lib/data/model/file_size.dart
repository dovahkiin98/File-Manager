import 'dart:io';

class FileSize {
  final String multitude;
  final double size;

  FileSize({
    required this.multitude,
    required this.size,
  });

  factory FileSize.forFile(
    FileSystemEntity file,
  ) {
    double size = file.statSync().size.toDouble();

    final multitudes = [
      'B',
      'KB',
      'MB',
      'GB',
      'TB',
    ];

    int multitudeIndex = 0;

    while (size > 1000) {
      multitudeIndex++;

      size = size / 1000;
    }

    return FileSize(
      multitude: multitudes[multitudeIndex],
      size: size,
    );
  }

  @override
  String toString() {
    return '${size.toStringAsFixed(2)} $multitude';
  }
}
