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

  /// Gets all the selected rows in the current resultset
  List<TResult> getSelectedRows() {
    return _state.selectedRows.entries.where((element) => element.value).map((e) => _state.tableCache.currentResultset[e.key]).toList();
  }

  /// Unselects any selected row in the current resultset
  void unselectAllRows() {
    _state.selectedRows.clear();
    for(var rowState in _state._rowsState) {
      if(rowState._isSelected) {
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
    } catch(_) {
      throw TableError("There is no row at index $rowIndex.");
    }
  }

  /// Rebuilds the row at the specified [rowIndex] to reflect changes to the item.
  void refreshRow(int rowIndex) {
    try {
      // refresh state of that row.
      _state._rowsState[rowIndex].refresh();
    } catch(_) {
      throw TableError("There is no row at index $rowIndex.");
    }
  }
}