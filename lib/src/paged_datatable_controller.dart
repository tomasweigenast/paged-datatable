// ignore_for_file: invalid_use_of_protected_member

part of 'paged_datatable.dart';

/// Represents a controller of a [PagedDataTable]
class PagedDataTableController<TKey extends Object, TResult extends Object> {
  late final _PagedDataTableState<TKey, TResult> _state;

  /// Returns the current showing dataset elements.
  Iterable<TResult> get currentDataset => _state._rowsState.map((e) => e.item);

  void dispose() {
    _state.dispose();
  }

  /// Refreshes the table clearing the cache and fetching from source again.
  /// If [currentDataset] is true, it will only refresh the current viewing resultset, otherwise,
  /// it will clear the local cache and start from page 1.
  void refresh({bool currentDataset = true}) {
    _state._refresh(currentDataset: currentDataset);
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

  /// Returns a Map where each key is the field name and its value the current field's value
  Map<String, dynamic> getFilters() {
    return _state.filters.map((key, value) => MapEntry(key, value.value));
  }

  /// Gets the value of a filter
  dynamic getFilter(String filterName) {
    return _state.filters[filterName]?.value;
  }

  /// Gets all the selected rows in the current resultset
  List<TResult> getSelectedRows() {
    return _state.selectedRows.entries
        .where((element) => element.value)
        .map((e) => _state.tableCache.currentResultset[e.key])
        .toList();
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
  void selectRow(int index) {
    _state.selectedRows[index] = true;
    _state._rowsState[index].selected = true;
  }

  /// Updates an item from the current resultset located at [rowIndex] and rebuilds the row.
  void modifyRowValue(int rowIndex, void Function(TResult item) update) {
    try {
      var row = _state.tableCache.currentResultset[rowIndex];
      update(row);

      // refresh state of that row.
      _state._rowsState[rowIndex].refresh();
    } catch (_) {
      throw TableError("There is no row at index $rowIndex.");
    }
  }

  /// Rebuilds the row at the specified [rowIndex] to reflect changes to the item.
  void refreshRow(int rowIndex) {
    try {
      // refresh state of that row.
      _state._rowsState[rowIndex].refresh();
    } catch (_) {
      throw TableError("There is no row at index $rowIndex.");
    }
  }

  /// Removes the row containing [element].
  /// Keep in mind this will work only if [TResult] defines a custom hashcode implementation.
  void removeRow(TResult element) {
    var rowStateIndex =
        _state._rowsState.indexWhere((elem) => elem.item == element);
    if (rowStateIndex != -1) {
      _state.tableCache.deleteFromCurrentDataset(element);
      _state._rowsState.removeAt(rowStateIndex);
      _state._rowsChange = rowStateIndex;
      // ignore: invalid_use_of_visible_for_testing_member
      _state.notifyListeners();
    }
  }
}
