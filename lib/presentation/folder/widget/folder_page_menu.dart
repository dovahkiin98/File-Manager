import 'package:file_manager/core/i10n.dart';
import 'package:file_manager/data/model/filter_type.dart';
import 'package:file_manager/data/model/sort_type.dart';
import 'package:flutter/material.dart';

class FolderPageMenu extends StatelessWidget {
  const FolderPageMenu({
    required this.filterType,
    required this.sortType,
    required this.sortOrder,
    required this.onFilterChanged,
    required this.onSortChanged,
    super.key,
  });

  final FilterType filterType;
  final SortType sortType;
  final SortOrder sortOrder;
  final Function(FilterType?) onFilterChanged;
  final Function(SortType?, SortOrder) onSortChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownMenu(
              menuStyle: MenuStyle(
                surfaceTintColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onSurface,
                ),
              ),
              initialSelection: filterType,
              width: 100,
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  value: FilterTypeAll(),
                  label: context.localizations.all,
                ),
                DropdownMenuEntry(
                  value: FilterTypeFolders(),
                  label: context.localizations.folders,
                ),
                DropdownMenuEntry(
                  value: FilterTypeFiles(),
                  label: context.localizations.files,
                ),
                DropdownMenuEntry(
                  value: FilterTypeImages(),
                  label: context.localizations.images,
                ),
                DropdownMenuEntry(
                  value: FilterTypeText(),
                  label: context.localizations.text_files,
                ),
              ],
              onSelected: onFilterChanged,
              inputDecorationTheme: const InputDecorationTheme(
                filled: false,
                border: InputBorder.none,
              ),
              textStyle: const TextStyle(
                fontSize: 12,
              ),
            ),
            const Expanded(child: SizedBox()),
            DropdownMenu(
              menuStyle: MenuStyle(
                surfaceTintColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onSurface,
                ),
              ),
              initialSelection: sortType,
              width: 100,
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  value: SortTypeName(),
                  label: context.localizations.name,
                ),
                DropdownMenuEntry(
                  value: SortTypeSize(),
                  label: context.localizations.size,
                ),
                DropdownMenuEntry(
                  value: SortTypeDateModified(),
                  label: context.localizations.date_modified,
                ),
              ],
              onSelected: (sort) {
                onSortChanged(sort, sortOrder);
              },
              inputDecorationTheme: const InputDecorationTheme(
                filled: false,
                border: InputBorder.none,
              ),
              textStyle: const TextStyle(
                fontSize: 12,
              ),
            ),
            const VerticalDivider(
              indent: 12,
              endIndent: 12,
            ),
            IconButton(
              onPressed: () {
                onSortChanged(sortType, sortOrder.flip());
              },
              icon: sortOrder == SortOrder.desc
                  ? const Icon(Icons.arrow_downward)
                  : const Icon(Icons.arrow_upward),
            ),
          ],
        ),
      ),
    );
  }
}
