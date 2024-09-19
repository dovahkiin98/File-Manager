import 'dart:async';

import 'package:collection/collection.dart';
import 'package:file/file.dart';
import 'package:file_manager/data/model/filter_type.dart';
import 'package:file_manager/data/model/sort_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'search_event.dart';
import 'search_state.dart';

export 'search_event.dart';
export 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required Directory directory,
  })  : _directory = directory,
        super(SearchStateInitial()) {
    on<SearchCheckPermissionsEvent>(_onCheckPermissions);

    on<SearchApplySearchEvent>(_onApplySearch);
    on<SearchRetryEvent>(_onRetry);

    on<SearchFilterChangedEvent>(_onFilterChanged);
    on<SearchSortChangedEvent>(_onSortChanged);
  }

  final Directory _directory;

  FilterType _filterType = FilterTypeAll();

  FilterType get filterType => _filterType;

  SortType _sortType = SortTypeName();

  SortType get sortType => _sortType;

  SortOrder _sortOrder = SortOrder.asc;

  SortOrder get sortOrder => _sortOrder;

  Timer? _timer;
  String? _lastQuery;

  static const debounce = Duration(milliseconds: 500);

  FutureOr<void> _onCheckPermissions(
    SearchCheckPermissionsEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchStateInitial());

    var permission = await Permission.manageExternalStorage.status;

    if (permission.isPermanentlyDenied) {
      emit(SearchStatePermissionError(isPermanent: true));
    } else {
      permission = await Permission.manageExternalStorage.request();

      if (!permission.isGranted) {
        emit(SearchStatePermissionError(
          isPermanent: permission.isPermanentlyDenied,
        ));
      }
    }
  }

  FutureOr<void> _onApplySearch(
    SearchApplySearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchStatePermissionError) {
      return;
    }

    if (event.query == _lastQuery) {
      return;
    }

    _lastQuery = event.query;

    await Future.delayed(debounce);

    if (_lastQuery != event.query) {
      return;
    }

    emit(SearchStateLoading());

    try {
      final entities = await _search(
        event.query,
        _directory,
      );

      _applyParams(entities, emit);
    } on FileSystemException catch (e) {
      emit(SearchStateError(e));
    }
  }

  FutureOr<void> _onRetry(
    SearchRetryEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (_lastQuery == null) {
      return;
    }

    add(SearchApplySearchEvent(_lastQuery!));
  }

  FutureOr<void> _onFilterChanged(
    SearchFilterChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.filter == _filterType) {
      return;
    }

    _filterType = event.filter;

    final state = this.state;

    if (state is! SearchStateSuccess) {
      return;
    }

    _applyParams(
      state.files,
      emit,
    );
  }

  FutureOr<void> _onSortChanged(
    SearchSortChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.sort == _sortType && event.order == _sortOrder) {
      return;
    }

    _sortType = event.sort;
    _sortOrder = event.order;

    final state = this.state;

    if (state is! SearchStateSuccess) {
      return;
    }

    _applyParams(
      state.files,
      emit,
    );
  }

  void _applyParams(
    Iterable<FileSystemEntity> entities,
    Emitter<SearchState> emit,
  ) {
    Iterable<FileSystemEntity> files = entities.whereNot((e) {
      return e is Link || e.basename.startsWith('.');
    });

    files = _filterType.apply(files);
    files = _sortType.apply(files, order: sortOrder);

    emit(SearchStateSuccess(files.toList(
      growable: false,
    )));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  /// We have resulted to manually searching inside
  /// each Directory, as some Directories might be forbidden
  ///
  /// To solve this, we simply skip any folder that throws an exception
  /// if we attempt to `list()` what's inside it
  Future<Iterable<FileSystemEntity>> _search(
    String query,
    Directory directory,
  ) async {
    List<FileSystemEntity> results = [];

    final list = await directory.list().toList();

    for (var e in list) {
      if (e is Directory) {
        try {
          final innerResults = await _search(query, e);
          results.addAll(innerResults);
        } catch (_) {}
      }

      if(e.basename.toLowerCase().contains(query.toLowerCase())) {
        results.add(e);
      }
    }

    return results;
  }
}
