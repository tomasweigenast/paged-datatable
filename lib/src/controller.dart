part of 'paged_datatable.dart';

typedef Fetcher<K extends Comparable<K>, T>
    = FutureOr<(List<T> resultset, K? nextPageToken)> Function(int pageSize,
        SortModel? sortModel, FilterModel filterModel, K? pageToken);

typedef RowChangeListener<K extends Comparable<K>, T> = void Function(
    int index, T item);

/// [PagedDataTableController] represents the state of a [PagedDataTable] of type [T], using pagination keys of type [K].
///
/// Is recommended that [T] specifies a custom hashCode and equals method for comparison reasons.
final class PagedDataTableController<K extends Comparable<K>, T>
    extends ChangeNotifier {
  final List<T> _currentDataset =
      []; // the current dataset that is being displayed
  final Map<String, FilterState> _filtersState =
      {}; // The list of filters' states
  final Map<int, K> _paginationKeys =
      {}; // it's a map because on not found map will return null, list will throw
  final Set<int> _selectedRows = {}; // The list of selected row indexes
  final GlobalKey<FormState> _filtersFormKey = GlobalKey();
  late final List<int>? _pageSizes;
  late final Fetcher<K, T> _fetcher; // The function used to fetch items
  final Map<_ListenerType, dynamic> _listeners = {
    // The list of special listeners which all are functions

    // Callbacks for row change. The key of the map is the row index, the value the list of listeners for the row
    _ListenerType.rowChange: <int, List<RowChangeListener<K, T>>>{},
  };
  PagedDataTableConfiguration? _configuration;

  Object?
      _currentError; // If something went wrong when fetching items, this is the latest error
  int _totalItems = 0; // the total items in the current dataset
  int _currentPageSize = 0;
  int _currentPageIndex =
      0; // The current index of the page, used to lookup token inside _paginationKeys
  bool _hasNextPage =
      false; // a flag that indicates if there are more pages after the current one
  SortModel? _currentSortModel; // The current sort model of the table
  _TableState _state = _TableState.idle;

  /// A flag that indicates if the dataaset has a next page
  bool get hasNextPage => _hasNextPage;

  /// A flag that indicates if the dataset has a previous page
  bool get hasPreviousPage => _currentPageIndex != 0;

  /// The current amount of items that are being displayed on the current page
  int get totalItems => _totalItems;

  /// The current page size
  int get pageSize => _currentPageSize;

  /// Sets the new page size for the table
  set pageSize(int pageSize) {
    _currentPageSize = pageSize;
    refresh(fromStart: true);
    notifyListeners();
  }

  /// The current sort model of the table
  SortModel? get sortModel => _currentSortModel;

  /// The list of selected row indexes
  List<int> get selectedRows => _selectedRows.toList(growable: false);

  /// Updates the sort model and refreshes the dataset
  set sortModel(SortModel? sortModel) {
    _currentSortModel = sortModel;
    refresh(fromStart: true);
    notifyListeners();
  }

  /// Swipes the current sort model or sets it to [columnId].
  ///
  /// If the sort model was ascending, it gets changed to descending, and finally it gets changed to null.
  void swipeSortModel([String? columnId]) {
    if (columnId != null && _currentSortModel?.fieldName != columnId) {
      sortModel = SortModel._(fieldName: columnId, descending: false);
      return;
    }

    // Ignore if no sort model
    if (_currentSortModel == null) return;

    if (_currentSortModel!.descending) {
      sortModel = null;
    } else {
      sortModel = SortModel._(
          fieldName: _currentSortModel!.fieldName, descending: true);
    }
  }

  /// Advances to the next page
  Future<void> nextPage() => _fetch(_currentPageIndex + 1);

  /// Comes back to the previous page
  Future<void> previousPage() => _fetch(_currentPageIndex - 1);

  /// Refreshes the state of the table.
  ///
  /// If [fromStart] is true, it will fetch from the first page. Otherwise, will try to refresh
  /// the current page.
  void refresh({bool fromStart = false}) {
    if (fromStart) {
      _paginationKeys.clear();
      _totalItems = 0;
      _fetch();
    } else {
      _fetch(_currentPageIndex);
    }
  }

  /// Prints a helpful debug string. Only works in debug mode.
  void printDebugString() {
    if (kDebugMode) {
      final buf = StringBuffer();
      buf.writeln("TableController<$T>(");
      buf.writeln("   CurrentPageIndex($_currentPageIndex),");
      buf.writeln("   PaginationKeys(${_paginationKeys.values.join(", ")}),");
      buf.writeln("   Error($_currentError)");
      buf.writeln("   CurrentPageSize($_currentPageSize)");
      buf.writeln("   TotalItems($_totalItems)");
      buf.writeln("   State($_state)");
      buf.writeln(")");

      debugPrint(buf.toString());
    }
  }

  /// Removes the row with [item] from the dataset.
  ///
  /// This will use item to lookup based on its hashcode, so if you don't implement a custom
  /// one, this may not remove anything.
  void removeRow(T item) {
    final index = _currentDataset.indexOf(item);
    removeRowAt(index);
    _notifyOnRowChanged(index);
  }

  /// Removes a row at the specified [index].
  void removeRowAt(int index) {
    if (index >= _totalItems) {
      throw ArgumentError(
          "index cannot be greater than or equals to the total list of items.",
          "index");
    }

    if (index < 0) {
      throw ArgumentError("index cannot be less than zero.", "index");
    }

    _currentDataset.removeAt(index);
    _totalItems--;
    _notifyOnRowChanged(index);
  }

  /// Inserts [value] in the current dataset at the specified [index]
  void insertAt(int index, T value) {
    _currentDataset.insert(index, value);
    _totalItems++;
    _notifyOnRowChanged(index);
  }

  /// Inserts [value] at the bottom of the current dataset
  void insert(T value) {
    insertAt(_totalItems, value);
    _notifyOnRowChanged(_totalItems);
  }

  /// Replaces the element at [index] with [value]
  void replace(int index, T value) {
    if (index >= _totalItems) {
      throw ArgumentError(
          "Index cannot be greater than or equals to the total size of the current dataset.",
          "index");
    }

    _currentDataset[index] = value;
    _notifyOnRowChanged(index);
  }

  /// Marks a row as selected
  void selectRow(int index) {
    _selectedRows.add(index);
    _notifyOnRowChanged(index);
  }

  /// Marks every row in the current resultset as selected
  void selectAllRows() {
    final iterable = Iterable<int>.generate(_totalItems);
    _selectedRows.addAll(iterable);
    _notifyRowChangedMany(iterable);
  }

  /// Unselects every row
  void unselectEveryRow() {
    final selectedRows = _selectedRows.toList(growable: false);
    _selectedRows.clear();
    _notifyRowChangedMany(selectedRows);
  }

  /// Unselects a row if was selected before
  void unselectRow(int index) {
    _selectedRows.remove(index);
    _notifyOnRowChanged(index);
  }

  /// Selects or unselects a row
  void toggleRow(int index) {
    if (_selectedRows.contains(index)) {
      _selectedRows.remove(index);
    } else {
      _selectedRows.add(index);
    }
    _notifyOnRowChanged(index);
  }

  /// Registers a callback that gets called when the row at [index] is updated.
  void addRowChangeListener(int index, RowChangeListener<K, T> onRowChange) {
    final listeners = _listeners[_ListenerType.rowChange]
        as Map<int, List<RowChangeListener<K, T>>>;
    final listenersForIndex = listeners[index] ?? [];
    listenersForIndex.add(onRowChange);
    listeners[index] = listenersForIndex;
  }

  /// Unregisters a row change callback.
  void removeRowChangeListener(
      int index, RowChangeListener<K, T> rowChangeListener) {
    final listeners = _listeners[_ListenerType.rowChange]
        as Map<int, List<RowChangeListener<K, T>>>;
    final listenersForIndex = listeners[index];
    if (listenersForIndex == null) return;

    int? toRemove;
    for (int i = 0; i < listenersForIndex.length; i++) {
      if (listenersForIndex[i] == rowChangeListener) {
        toRemove = i;
        break;
      }
    }

    if (toRemove != null) listenersForIndex.removeAt(toRemove);
  }

  /// Removes a filter, changing its value to null.
  void removeFilter(String filterId) {
    final filter = _filtersState[filterId];
    if (filter == null) {
      throw ArgumentError("Filter with id $filterId not found.");
    }

    filter.value = null;
    notifyListeners();
    _fetch();
  }

  /// Removes all the set filters, changing their values to null.
  void removeFilters() {
    _filtersState.forEach((key, value) {
      value.value = null;
    });
    notifyListeners();
    _fetch();
  }

  /// Applies the current set filters
  void applyFilters() {
    if (_filtersState.values.any((element) => element.value != null)) {
      notifyListeners();
      _fetch();
    }
  }

  /// Sets filter [filterId]'s value.
  void setFilter(String filterId, dynamic value) {
    final filterState = _filtersState[filterId];
    if (filterState == null) {
      throw ArgumentError(
          "Filter with id $filterId does not exist.", "filterId");
    }

    filterState.value = value;
    notifyListeners();
  }

  /// This method automatically calls notifyListeners too.
  void _notifyOnRowChanged(int rowIndex) {
    final listeners = (_listeners[_ListenerType.rowChange]
        as Map<int, List<RowChangeListener<K, T>>>)[rowIndex];
    if (listeners != null) {
      final item = _currentDataset[rowIndex]!;
      for (final listener in listeners) {
        listener(rowIndex, item);
      }
    }
    notifyListeners();
  }

  /// This method automatically calls notifyListeners too.
  void _notifyRowChangedMany(Iterable<int> indexes) {
    final listeners = (_listeners[_ListenerType.rowChange]
        as Map<int, List<RowChangeListener<K, T>>>);
    for (final index in indexes) {
      final listenerGroup = listeners[index];
      if (listenerGroup != null) {
        final value = _currentDataset[index]!;
        for (final listener in listenerGroup) {
          listener(index, value);
        }
      }
    }
    notifyListeners();
  }

  /// Initializes the controller filling up properties
  void _init({
    required List<ReadOnlyTableColumn> columns,
    required List<int>? pageSizes,
    required int initialPageSize,
    required Fetcher<K, T> fetcher,
    required List<TableFilter> filters,
    required PagedDataTableConfiguration config,
  }) {
    if (_configuration != null) return;

    assert(columns.isNotEmpty, "columns cannot be empty.");

    _currentPageSize = initialPageSize;
    _pageSizes = pageSizes;
    _configuration = config;
    _fetcher = fetcher;
    _filtersState.addEntries(
        filters.map((filter) => MapEntry(filter.id, filter.createState())));

    // Schedule a fetch
    Future.microtask(_fetch);
  }

  void _reset({required List<ReadOnlyTableColumn> columns}) {
    assert(columns.isNotEmpty, "columns cannot be empty.");

    // Schedule a fetch
    Future.microtask(_fetch);
  }

  Future<void> _fetch([int page = 0]) async {
    _state = _TableState.fetching;
    notifyListeners();

    try {
      final pageToken = _paginationKeys[page];
      final filterModel = FilterModel._(
          _filtersState.map((key, value) => MapEntry(key, value.value)));

      var (items, nextPageToken) =
          await _fetcher(_currentPageSize, sortModel, filterModel, pageToken);
      _hasNextPage = nextPageToken != null;
      _currentPageIndex = page;
      if (nextPageToken != null) {
        _paginationKeys[page + 1] = nextPageToken;
      }

      if (_configuration!.copyItems) {
        items = items.toList();
      }

      /* the following may be more efficient than clearing the list and adding items again */

      // if no items, clear dataset
      if (items.isEmpty) {
        _currentDataset.clear();
      }

      // if no items before, just add all
      else if (_totalItems == 0) {
        _currentDataset.addAll(items);
      }

      // if now more items than before, replace then add
      else if (items.length > _totalItems) {
        _currentDataset.replaceRange(0, _totalItems - 1, items);
      }

      // if now less than items than before, replace and remove
      else {
        _currentDataset.replaceRange(0, items.length - 1, items);
        if (items.length < _totalItems) {
          _currentDataset.removeRange(items.length, _totalItems - 1);
        }
      }

      _totalItems = items.length;
      _state = _TableState.idle;
      _currentError = null;
      notifyListeners();
    } catch (err, stack) {
      debugPrint("An error occurred trying to fetch a page: $err");
      debugPrint(stack.toString());
      _state = _TableState.error;
      _currentError = err;
      _totalItems = 0;
      _currentDataset.clear();
      notifyListeners();
    }
  }
}

enum _TableState {
  idle,
  fetching,
  error,
}

enum _ListenerType {
  rowChange,
}
