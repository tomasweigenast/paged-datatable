part of 'paged_datatable.dart';

/// [TableController] represents the state of a [PagedDataTable] of type [T], using pagination keys of type [K].
///
/// Is recommended that [T] specifies a custom hashCode and equals method for comparison reasons.
final class TableController<K extends Comparable<K>, T> extends ChangeNotifier {
  final List<T> _currentDataset = []; // the current dataset that is being displayed
  final Map<int, K> _paginationKeys = {}; // it's a map because on not found map will return null, list will throw
  PagedDataTableConfiguration? _configuration;
  late final Fetcher<K, T> _fetcher; // The function used to fetch items

  Object? _currentError; // If something went wrong when fetching items, the error
  int _totalItems = 0; // the total items in the current dataset
  int _currentPageSize = 0;
  int _currentPageIndex = 0; // The current index of the page, used to lookup token inside _paginationKeys
  bool _hasNextPage = false; // a flag that indicates if there are more pages after the current one
  SortModel? _currentSortModel; // The current sort model of the table
  _TableState _state = _TableState.idle;

  /// A flag that indicates if the dataaset has a next page
  bool get hasNextPage => _hasNextPage;

  /// A flag that indicates if the dataset has a previous page
  bool get hasPreviousPage => _currentPageIndex != -1;

  /// The current amount of items that are being displayed on the current page
  int get totalItems => _totalItems;

  /// The current sort model of the table
  SortModel? get sortModel => _currentSortModel;

  /// Updates the sort model and refreshes the dataset
  set sortModel(SortModel? sortModel) {
    _currentSortModel = sortModel;
    refresh(fromStart: true);
    notifyListeners();
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
  void removeRow(T item) => removeRowAt(_currentDataset.indexOf(item));

  /// Removes a row at the specified [index].
  void removeRowAt(int index) {
    if (index >= _totalItems) {
      throw ArgumentError("index cannot be greater than or equals to the total list of items.", "index");
    }

    if (index < 0) {
      throw ArgumentError("index cannot be less than zero.", "index");
    }

    _currentDataset.removeAt(index);
    _totalItems--;
    notifyListeners();
  }

  /// Inserts [value] in the current dataset at the specified [index]
  void insertAt(int index, T value) {
    _currentDataset.insert(index, value);
    _totalItems++;
    notifyListeners();
  }

  /// Inserts [value] at the bottom of the current dataset
  void insert(T value) => insertAt(_totalItems, value);

  /// Replaces the element at [index] with [value]
  void replace(int index, T value) {
    if (index >= _totalItems) {
      throw ArgumentError("Index cannot be greater than or equals to the total size of the current dataset.", "index");
    }

    _currentDataset[index] = value;
    notifyListeners();
  }

  /// Initializes the controller filling up properties
  void _init({
    required List<ReadOnlyTableColumn> columns,
    required int initialPageSize,
    required Fetcher<K, T> fetcher,
    required PagedDataTableConfiguration config,
  }) {
    if (_configuration != null) return;

    assert(columns.isNotEmpty, "columns cannot be empty.");

    _currentPageSize = initialPageSize;
    _configuration = config;
    _fetcher = fetcher;

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
      var (items, nextPageToken) = await _fetcher(_currentPageSize, pageToken);
      _hasNextPage = nextPageToken != null;
      _currentPageIndex = page;
      if (nextPageToken != null) {
        _paginationKeys[page + 1] = nextPageToken;
      }

      if (_configuration!.copyItems) {
        items = items.toList();
      }

      if (_totalItems == 0) {
        _currentDataset.addAll(items);
      } else {
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
