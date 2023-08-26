// ignore_for_file: invalid_use_of_protected_member

part of 'paged_datatable.dart';

/// Represents a controller of a [PagedDataTable]
class PagedDataTableController<TKey extends Comparable, TResultId extends Comparable,
    TResult extends Object> {
  late final _PagedDataTableState<TKey, TResultId, TResult> _state;

  /// Returns the current showing dataset elements.
  Iterable<TResult> get currentDataset => _state._rowsState.map((e) => e.item);

  void dispose() {
    _state.dispose();
  }

  /// Refreshes the table fetching from source again.
  /// If [currentDataset] is true, it will only refresh the current viewing resultset, otherwise,
  /// it will start from page 1.
  void refresh({bool currentDataset = true}) {
    _state._refresh(initial: !currentDataset);
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

  /// Returns a Map where each key is the field name and its value the current field's value
  Map<String, dynamic> getFilters() {
    return _state.filters.map((key, value) => MapEntry(key, value.value));
  }

  /// Gets the value of a filter
  dynamic getFilter(String filterName) {
    return _state.filters[filterName]?.value;
  }

  /// Returns a list of the selected rows id.
  List<TResultId> getSelectedRows() {
    return _state.selectedRows.keys.toList();
  }

  /// Unselects any selected row in the current resultset
  void unselectAllRows() {
    _state.selectedRows.clear();
    for (var rowState in _state._rowsState) {
      if (rowState._isSelected) {
        rowState.selected = false;
      }
    }
  }

  /// Marks the row at [index] as selected
  void selectRow(TResultId key) {
    _state.selectedRows[key] = true;
    _state._rowsState.firstWhere((element) => element.itemId == key).selected = true;
  }

  /// Builds every row that matches [predicate].
  void refreshRowWhere(bool Function(TResult element) predicate) {
    var elements = _state._rowsState.where((state) => predicate(state.item));
    for (var elem in elements) {
      elem.refresh();
    }
  }

  /// Updates every item from the current resultset that matches [predicate] and rebuilds it.
  void modifyRowsValue(
      bool Function(TResult element) predicate, void Function(TResult item) update) {
    int index = 0;
    for (final item in _state._items) {
      if (predicate(item)) {
        update(item);
        _state._rowsState[index].refresh();
      }

      index++;
    }
  }

  /// Updates an item from the current resultset with the id [itemId] and rebuilds the row.
  void modifyRowValue(TResultId itemId, void Function(TResult item) update) {
    try {
      final row = _state._rowsState.firstWhere((element) => element.itemId == itemId);
      final item = _state._items[row.index];
      update(item);

      // refresh state of that row.
      row.refresh();
    } catch (_) {
      throw TableError("There is no row with id $itemId.");
    }
  }

  /// Rebuilds the row which has the specified [itemId] to reflect changes to the item.
  void refreshRow(TResultId itemId) {
    try {
      // refresh state of that row.
      _state._rowsState.firstWhere((element) => element.itemId == itemId).refresh();
    } catch (_) {
      throw TableError("There is not item with id $itemId.");
    }
  }

  /// Removes the row containing [element].
  /// Keep in mind this will work only if [TResult] defines a custom hashcode implementation.
  void removeRow(TResult element) {
    var rowStateIndex = _state._rowsState.indexWhere((elem) => elem.item == element);
    if (rowStateIndex != -1) {
      _state._rowsState.removeAt(rowStateIndex);
      _state._items.removeAt(rowStateIndex);
      _state._rowsChange = rowStateIndex;
      // ignore: invalid_use_of_visible_for_testing_member
      _state.notifyListeners();
    }
  }
}
