import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:file_manager/data/model/filter_type.dart';
import 'package:file_manager/data/model/sort_type.dart';
import 'package:file_manager/presentation/folder/bloc/folder_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FolderBloc Tests', () {
    late Directory baseDirectory;

    setUp(() {
      final fileSystem = MemoryFileSystem();

      baseDirectory = fileSystem.directory('/');

      baseDirectory.create();

      for (int i = 0; i < 3; i++) {
        baseDirectory.childDirectory('#${'${i + 1}'.padLeft(2, '0')}').create();
      }
    });

    blocTest<FolderBloc, FolderState>(
      '`FolderCreateEvent` creates a new folder',
      build: () => FolderBloc(
        directory: baseDirectory,
      ),
      act: (bloc) {
        bloc.add(FolderCreateEvent(name: '#04'));
      },
      verify: (_) {
        var files = baseDirectory.listSync();

        expect(
          files.firstWhereOrNull((e) {
            return e.basename == '#04';
          }),
          isNotNull,
        );
      },
    );

    blocTest<FolderBloc, FolderState>(
      '`FolderDeleteEvent` should delete folder',
      build: () => FolderBloc(
        directory: baseDirectory,
      ),
      act: (bloc) {
        bloc.add(FolderDeleteEvent(
          file: baseDirectory.childDirectory('#03'),
        ));
      },
      verify: (_) {
        var files = baseDirectory.listSync();

        expect(
          files.firstWhereOrNull((e) {
            return e.basename == '#03';
          }),
          isNull,
        );
      },
    );

    blocTest<FolderBloc, FolderState>(
      '`FolderRenameEvent` should rename folder',
      build: () => FolderBloc(
        directory: baseDirectory,
      ),
      act: (bloc) {
        bloc.add(FolderRenameEvent(
          name: '#04',
          file: baseDirectory.childDirectory('#03'),
        ));
      },
      verify: (_) {
        var files = baseDirectory.listSync();

        expect(
          files.firstWhereOrNull((e) {
            return e.basename == '#03';
          }),
          isNull,
        );

        expect(
          files.firstWhereOrNull((e) {
            return e.basename == '#04';
          }),
          isNotNull,
        );
      },
    );

    blocTest<FolderBloc, FolderState>(
      '`FolderSortChangedEvent` with `SortTypeName() desc` should sort by name',
      setUp: () {
        final names = [
          'B',
          'C',
          'A',
        ];

        for (int i = 0; i < 3; i++) {
          baseDirectory.childDirectory(names[i]).create();
        }
      },
      build: () => FolderBloc(
        directory: baseDirectory,
      ),
      act: (bloc) {
        bloc.add(FolderSortChangedEvent(
          order: SortOrder.desc,
          sort: SortTypeName(),
        ));
      },
      verify: (bloc) {
        var files = (bloc.state as FolderStateSuccess).files;

        final indexOfA = files.indexWhere((e) => e.basename == 'A');
        final indexOfB = files.indexWhere((e) => e.basename == 'B');

        expect(
          indexOfB < indexOfA,
          true,
        );
      },
    );

    blocTest<FolderBloc, FolderState>(
      '`FolderFilterChangedEvent` with `FilterTypeFiles` should return only files',
      setUp: () {
        final names = [
          'B.txt',
          'C.txt',
          'A.txt',
        ];

        for (int i = 0; i < 3; i++) {
          baseDirectory.childFile(names[i]).create();
        }
      },
      build: () => FolderBloc(
        directory: baseDirectory,
      ),
      act: (bloc) {
        bloc.add(FolderFilterChangedEvent(
          FilterTypeFiles(),
        ));
      },
      verify: (bloc) {
        var files = (bloc.state as FolderStateSuccess).files;

        expect(
          files.none((e) => e is Directory),
          true,
        );
      },
    );
  });
}
