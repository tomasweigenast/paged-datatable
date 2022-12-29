part of 'paged_datatable.dart';

class _PagedDataTableState<TKey extends Object, TResult extends Object> extends ChangeNotifier {
  int _pageSize = 100;
  SortBy? _sortBy;
  _TableState _state = _TableState.loading;
  
  final PagedDataTableController<TKey, TResult> controller;
  final FetchCallback<TKey, TResult> fetchCallback;
  final TKey initialPage;
  final Size viewSize;
  final List<TableColumn<TResult>> columns;
  final List<TResult> currentItems = [];

  _TableState get state => _state;
  bool get isSorted => _sortBy != null;

  _PagedDataTableState({
    required this.fetchCallback,
    required this.initialPage,
    required this.viewSize,
    required this.columns,
    PagedDataTableController<TKey, TResult>? controller
  }) : 
    controller = controller ?? PagedDataTableController() {
      assert(columns.map((e) => e.sizeFactor).sum < 1, "the sum of all sizeFactor must be less than 1");
      _dispatchCallback();
    }

  void setPageSize(int pageSize) {
    _pageSize = pageSize;
    notifyListeners();
    _dispatchCallback();
  }

  void setSortBy(String columnId, bool descending) {
    if(_sortBy?.columnId == columnId && _sortBy?.descending == descending) {
      return;
    }

    _sortBy = SortBy._internal(columnId: columnId, descending: descending);
    notifyListeners();
    _dispatchCallback();
  }

  void swapSortBy(String columnId) {
    if(_sortBy != null && _sortBy!.columnId == columnId) {
      _sortBy!._descending = !_sortBy!.descending;
    } else {
      _sortBy = SortBy._internal(columnId: columnId, descending: true);
    }
    notifyListeners();
    _dispatchCallback();
  }

  Future<void> _dispatchCallback() async {
    _state = _TableState.loading;
    try {
      var pageIndicator = await fetchCallback(initialPage, _pageSize, _sortBy);
      currentItems.clear();
      currentItems.addAll(pageIndicator.elements);
      notifyListeners();
      _state = _TableState.displaying;
    } catch(err, stack) {
      debugPrint("An error ocurred trying to fetch elements from source. Error: $err");
      debugPrint(stack.toString());
      _state = _TableState.error;
    }
  }
}

/// Represents the current state of the rows itself
enum _TableState {
  loading, // for loading elements
  error, // when the table broke due to an error
  displaying // when showing elements
}