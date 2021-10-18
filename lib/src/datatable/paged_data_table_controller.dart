part of 'paged_data_table.dart';

class PagedDataTableController<T> {
  
  final StreamController _eventsNotifier = StreamController.broadcast();
  PagedDataTableState<T>? _state;

  Stream get _onEvent => _eventsNotifier.stream;

  /// Refresh the table.
  /// If [clearCache] is true, then the entire table will be reset and fetch from initial page,
  /// otherwise, only the current page will be refreshed.
  void refresh({bool clearCache = false}) {
    _eventsNotifier.add(_PagedDataTableControllerResetEvent(clearCache: clearCache));
  }

  /// Gets a list of all the selected rows.
  List<T> getSelectedRows() {
    return _state == null ? List.empty() : UnmodifiableListView(_state!.selectedRows.entries.where((element) => element.value).map((e) => e.key));
  }

  /// Marks a row as selected or not.
  void setRowSelected(T item, bool selected) {
    _state?.setRowSelected(item, selected);
  }

  /// Sets a filter value.
  /// If the filter does not exist, its created.
  /// If filters are not configured in the table, an error is thrown.
  void setFilterValue(String filterId, Object? newValue) {
    if(_state?.filterState == null) {
      throw StateError("Filters are not enabled in the table.");
    }

    _state!.filterState!.setFilterValue(filterId, newValue, create: true, notify: true, apply: true);
  }

  /// Removes a filter.
  /// If filters are not configured in the table, an error is thrown.
  void removeFilter(String filterId) {
    if(_state?.filterState == null) {
      throw StateError("Filters are not enabled in the table.");
    }

    _state!.filterState!.removeFilter(filterId);
  }

  /// Clears all the applied filters.
  /// If filters are not configured in the table, an error is thrown.
  void clearFilters() {
    _state!.filterState!.clearFilters();
  }

  void dispose() {
    _eventsNotifier.close();
  }
}

class _PagedDataTableControllerResetEvent {
  final bool clearCache;

  _PagedDataTableControllerResetEvent({required this.clearCache});
}