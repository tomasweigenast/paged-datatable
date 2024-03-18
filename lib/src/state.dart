part of 'paged_datatable.dart';

/// [TableController] represents the state of a [PagedDataTable] of type [T], using pagination keys of type [K].
final class TableController<K extends Comparable<K>, T> extends ChangeNotifier {
  final List<T> _currentDataset = []; // the current dataset that is being displayed
  final Map<int, K> _paginationKeys = {}; // it's a map because on not found map will return null, list will throw
  late final Fetcher<K, T> _fetcher; // The function used to fetch items

  Object? _currentError; // If something went wrong when fetching items, the error
  int _totalItems = 0; // the total items in the current dataset
  int _currentPageSize = 0;
  int _currentPageIndex = 0; // The current index of the page, used to lookup token inside _paginationKeys
  bool _hasNextPage = false; // a flag that indicates if there are more pages after the current one

  _TableState _state = _TableState.idle;

  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _currentPageIndex != -1;
  int get totalItems => _totalItems;

  /// Advances to the next page
  Future<void> nextPage() => _fetch(_currentPageIndex + 1);

  /// Comes back to the previous page
  Future<void> previousPage() => _fetch(_currentPageIndex - 1);

  /// Prints a helpful debug string. Only works in debugMode.
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

  /// Initializes the controller filling up properties
  void _init({
    required List<ReadOnlyTableColumn> columns,
    required int initialPageSize,
    required Fetcher<K, T> fetcher,
  }) {
    assert(columns.isNotEmpty, "columns cannot be empty.");

    _currentPageSize = initialPageSize;
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
      final (items, nextPageToken) = await _fetcher(_currentPageSize, pageToken);
      _hasNextPage = nextPageToken != null;
      _currentPageIndex = page;
      if (nextPageToken != null) {
        _paginationKeys[page + 1] = nextPageToken;
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
