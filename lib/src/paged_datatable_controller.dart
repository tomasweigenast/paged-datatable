part of 'paged_datatable.dart';

/// Represents a controller of a [PagedDataTable]
class PagedDataTableController<TKey extends Object, TResult extends Object> {
  late final _PagedDataTableState<TKey, TResult> _state;

  void dispose() {
    _state.dispose();
  }

  /// Refreshes the table clearing the cache and fetching from source again.
  void refresh() {
    _state._refresh();
    // _controller.add(_ControllerEvent(_ControllerEventType.refresh, null));
  }

  /// Sets a filter and fetches items from source.
  void setFilter(String id, dynamic value) {
    _state.applyFilter(id, value);
  }

  /// Removes a filter and fetches items from source.
  void removeFilter(String id) {
    _state.removeFilter(id);
  }

  /// Removes any applied filter.
  void removeFilters() {
    _state.removeFilters();
  }
}