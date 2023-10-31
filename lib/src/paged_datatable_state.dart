part of 'paged_datatable.dart';

/// [_PagedDataTableState] represents the "current" state of the table.
class _PagedDataTableState<
    TKey extends Comparable,
    TResultId extends Comparable,
    TResult extends Object> extends ChangeNotifier {
  int _pageSize;
  SortBy? _sortModel;
  Object? _currentError;
  _TableState _state = _TableState.loading;

  // A map that contains the state of the rows in the current resultset
  List<_PagedDataTableRowState<TResultId, TResult>> _rowsState = const [];

  /// Maps an item id with its index in the [_rowsState] list.
  Map<TResultId, int> _rowsStateMapper = const {};

  /// The list of items in the current resulset.
  List<TResult> _items = const [];

  /// The list of pagination keys used
  Map<int, TKey> _paginationKeys;

  /// The current page token
  int _currentPageIndex = 0;

  /// Indicates if there is another page after [_currentPageIndex]
  bool _hasNextPage = false;

  // the available width for the table
  double _availableWidth = 0;

  // the width applied to every column that has sizeFactor = null
  double _nullSizeFactorColumnsWidth = 0;

  // an int which changes when the sort column should update
  int _sortChange = 0;
  int _rowsChange = 0;
  int _rowsSelectionChange = 0;
  StreamSubscription? _refreshListenerSubscription;

  final TKey initialPage;
  final Stream? refreshListener;
  final ScrollController filterChipsScrollController = ScrollController();
  final ScrollController rowsScrollController = ScrollController();
  final PagedDataTableController<TKey, TResultId, TResult> controller;
  final FetchCallback<TKey, TResult> fetchCallback;
  final List<BaseTableColumn<TResult>> columns;
  final Map<String, TableFilterState> filters;
  final ModelIdGetter<TResultId, TResult> idGetter;
  final GlobalKey<FormState> filtersFormKey = GlobalKey();
  final bool rowsSelectable;
  late final double columnsSizeFactor;
  late final int lengthColumnsWithoutSizeFactor;

  /// Contains a list of selected rows. If the page changes, this remain untouched.
  final Map<TResultId, int> selectedRows = {};

  _TableState get tableState => _state;
  bool get hasSortModel => _sortModel != null;
  int get currentPage => _currentPageIndex + 1;
  Object? get currentError => _currentError;
  bool get hasPreviousPage => _currentPageIndex > 0;
  bool get hasNextPage => _hasNextPage;

  set availableWidth(double newWidth) {
    _availableWidth = newWidth;

    // subtract all the columns that has a specific sizeFactor
    _availableWidth = _availableWidth - (_availableWidth * columnsSizeFactor);
    _nullSizeFactorColumnsWidth =
        _availableWidth / lengthColumnsWithoutSizeFactor; // equally distributed
  }

  _PagedDataTableState(
      {required this.fetchCallback,
      required this.initialPage,
      required this.columns,
      required this.idGetter,
      required this.rowsSelectable,
      required List<TableFilter>? filters,
      required PagedDataTableController<TKey, TResultId, TResult>? controller,
      required this.refreshListener,
      required int pageSize})
      : controller = controller ?? PagedDataTableController(),
        _pageSize = pageSize,
        _paginationKeys = {0: initialPage},
        filters = filters == null
            ? {}
            : {for (var v in filters) v.id: TableFilterState._internal(v)} {
    _init();
  }

  void setPageSize(int pageSize) {
    _pageSize = pageSize;
    notifyListeners();
    _resetPagination();
    _dispatchCallback();
  }

  void setSortBy(String columnId, bool descending) {
    if (_sortModel?.columnId == columnId &&
        _sortModel?.descending == descending) {
      return;
    }

    _sortModel = SortBy._internal(columnId: columnId, descending: descending);
    _sortChange++;
    notifyListeners();
    _resetPagination();
    _dispatchCallback();
  }

  void swapSortBy(String columnId) {
    if (_sortModel != null && _sortModel!.columnId == columnId) {
      _sortModel!._descending = !_sortModel!.descending;
    } else {
      _sortModel = SortBy._internal(columnId: columnId, descending: true);
    }
    _sortChange++;
    notifyListeners();
    _resetPagination();
    _dispatchCallback();
  }

  void applyFilters() {
    if (filters.values.any((element) => element.hasValue)) {
      notifyListeners();
      _resetPagination();
      _dispatchCallback();
    }
  }

  void applyFilter(String filterId, dynamic value) {
    var filter = filters[filterId];
    if (filter == null) {
      throw TableError("Filter $filterId not found.");
    }

    filter.value = value;
    notifyListeners();
    _resetPagination();
    _dispatchCallback();
  }

  void removeFilters() {
    bool changed = false;
    for (var filterState in filters.values) {
      if (filterState.hasValue) {
        filterState.value = null;
        changed = true;
      }
    }

    if (changed) {
      notifyListeners();
      _resetPagination();
      _dispatchCallback();
    }
  }

  void removeFilter(String filterId) {
    filters[filterId]?.value = null;
    notifyListeners();
    _resetPagination();
    _dispatchCallback();
  }

  void selectRow(TResultId itemId) {
    final itemIndex = _rowsStateMapper[itemId];
    if (itemIndex == null) {
      return;
    }

    selectedRows[itemId] = itemIndex;
    _rowsState[itemIndex].selected = true;
    _rowsSelectionChange = itemIndex;
    notifyListeners();
  }

  void unselectRow(TResultId itemId) {
    final itemIndex = _rowsStateMapper[itemId];
    if (itemIndex == null) {
      return;
    }

    selectedRows.remove(itemId);
    _rowsState[itemIndex].selected = false;
    _rowsSelectionChange = itemIndex;
    notifyListeners();
  }

  void selectAllRows() {
    for (var element in _rowsState) {
      selectedRows[element.itemId] = element.index;
      element.selected = true;
    }
    _rowsSelectionChange = -1;
    notifyListeners();
  }

  void unselectAllRows() {
    for (var element in _rowsState) {
      selectedRows.remove(element.itemId);
      element.selected = false;
    }
    _rowsSelectionChange = -2;
    notifyListeners();
  }

  Future<void> nextPage() => _dispatchCallback(page: _currentPageIndex + 1);

  Future<void> previousPage() => _dispatchCallback(page: _currentPageIndex - 1);

  @override
  void dispose() {
    rowsScrollController.dispose();
    filterChipsScrollController.dispose();
    _refreshListenerSubscription?.cancel();
    super.dispose();
  }

  /// Calls [fetchCallback].
  ///
  /// [page] indicates the index of the page in the [_paginationKeys] list.
  Future<void> _dispatchCallback({int page = 0}) async {
    _state = _TableState.loading;
    _rowsChange++;
    _currentError = null;
    selectedRows.clear();
    notifyListeners();

    TKey lookupKey = _paginationKeys[page]!;

    try {
      // fetch elements
      var pageIndicator = await fetchCallback(
          lookupKey, _pageSize, _sortModel, Filtering._internal(filters));

      // if has errors, throw it and let "catch" handle it
      if (pageIndicator.hasError) {
        throw pageIndicator.error;
      }

      if (pageIndicator.hasNextPageToken) {
        _paginationKeys[page + 1] = pageIndicator.nextPageToken!;
      }
      _hasNextPage = pageIndicator.hasNextPageToken;
      _currentPageIndex = page;

      // change state and notify listeners of update
      _state = _TableState.displaying;
      _rowsChange++;
      _items = pageIndicator.elements;
      _rowsState = [];
      _rowsStateMapper = {};
      int index = 0;
      for (final item in _items) {
        final itemId = idGetter(item);
        _rowsState.add(_PagedDataTableRowState(index, item, itemId));
        _rowsStateMapper[itemId] = index;
        index++;
      }
      notifyListeners();

      if (rowsScrollController.hasClients) {
        rowsScrollController.animateTo(0,
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      }
    } catch (err, stack) {
      debugPrint(
          'An error ocurred trying to fetch elements from key "$lookupKey". Error: $err');
      debugPrint(stack.toString());

      // store the error so the errorBuilder can display it
      _state = _TableState.error;
      _rowsChange++;
      _currentError = err;
      notifyListeners();
    }
  }

  /// Refreshes the datatable
  Future<void> _refresh({bool initial = false}) {
    if (initial) {
      _resetPagination();
    }
    return _dispatchCallback();
  }

  @pragma("vm:prefer-inline")
  void _init() {
    _initSizes();
    _setDefaultFilters();
    _dispatchCallback();
    controller._state = this;

    if (refreshListener != null) {
      _refreshListenerSubscription = refreshListener!.listen((event) {
        _refresh();
      });
    }
  }

  @pragma("vm:prefer-inline")
  void _setDefaultFilters() {
    for (var filter in filters.values) {
      if (filter._filter.defaultValue != null) {
        filter.value = filter._filter.defaultValue;
      }
    }
  }

  @pragma("vm:prefer-inline")
  void _initSizes() {
    int withoutSizeFactor = rowsSelectable ? 1 : 0;
    double sizeFactorSum = 0;

    for (var column in columns) {
      if (column.sizeFactor == null) {
        withoutSizeFactor++;
      } else {
        sizeFactorSum += column.sizeFactor!;
      }
    }

    columnsSizeFactor = sizeFactorSum;
    lengthColumnsWithoutSizeFactor = withoutSizeFactor;
    assert(columnsSizeFactor <= 1,
        "the sum of all sizeFactor must be less than or equals to 1, given $columnsSizeFactor");
  }

  @pragma("vm:prefer-inline")
  void _resetPagination() {
    _paginationKeys = {0: initialPage};
    _currentPageIndex = 0;
  }
}

/// Represents the current state of the rows itself
enum _TableState {
  loading, // for loading elements
  error, // when the table broke due to an error
  displaying // when showing elements
}

class TableFilterState<TValue> {
  final TableFilter<TValue> _filter;
  dynamic value;

  bool get hasValue => value != null;

  TableFilterState._internal(this._filter);
}
