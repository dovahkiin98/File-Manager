import 'package:file/file.dart';
import 'package:file_manager/core/utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:video_compress/video_compress.dart';

import '../file_popup_menu.dart';

class FileListItem extends StatelessWidget {
  const FileListItem({
    required this.file,
    this.onTap,
    this.selected = false,
    this.onPopupSelected,
    super.key,
  });

  final File file;
  final bool selected;
  final Function(File)? onTap;
  final Function(FilePopupResult)? onPopupSelected;

  @override
  Widget build(BuildContext context) {
    final stats = file.statSync();

    return ListTile(
      leading: leading(),
      minLeadingWidth: 36,
      title: Text(
        file.basename,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              formatedModified(
                context: context,
                entity: file,
              ),
            ),
          ),
          Text(
            sizeText(file),
          ),
        ],
      ),
      trailing: onPopupSelected != null
          ? FilePopupMenu(
              onSelected: onPopupSelected,
            )
          : null,
      contentPadding: EdgeInsetsDirectional.only(
        start: 8,
        end: onPopupSelected != null ? 8 : 16,
      ),
      onTap: onTap != null
          ? () {
              onTap!(file);
            }
          : null,
    );
  }

  Widget leading() {
    final fileExtension = extension(file.path);

    if (imageExtensions.contains(fileExtension)) {
      return Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Image.file(
          file,
          fit: BoxFit.cover,
        ),
      );
    }

    if (fileExtension == '.svg') {
      return Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.hardEdge,
        child: SvgPicture.file(
          file,
          fit: BoxFit.cover,
        ),
      );
    }

    if (videoExtensions.contains(fileExtension)) {
      return Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.hardEdge,
        child: FutureBuilder(
          future: VideoCompress.getByteThumbnail(file.path),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Icon(fileIcon(file));
            }

            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
            );
          },
        ),
      );
    }

    return SizedBox.square(
      dimension: 48,
      child: Icon(fileIcon(file)),
    );
  }
}
