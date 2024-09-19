import 'package:file_manager/data/model/filter_type.dart';
import 'package:file_manager/data/model/sort_type.dart';

abstract class SearchEvent {}

class SearchCheckPermissionsEvent extends SearchEvent {}

class SearchApplySearchEvent extends SearchEvent {
  final String query;

  SearchApplySearchEvent(this.query);
}

class SearchRetryEvent extends SearchEvent {}

class SearchFilterChangedEvent extends SearchEvent {
  final FilterType filter;

  SearchFilterChangedEvent(this.filter);
}

class SearchSortChangedEvent extends SearchEvent {
  final SortType sort;
  final SortOrder order;

  SearchSortChangedEvent({
    required this.sort,
    required this.order,
  });
}
