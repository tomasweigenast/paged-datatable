import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/paged_data_table_event.dart';
import 'package:paged_datatable/src/datatable/state/paged_data_table_filter_state.dart';

class PagedDataTableState<T> extends ChangeNotifier {
  final Map<String, TablePage<T>> _pageCache = {};
  final PageResolver<T> _pageResolver;
  final StreamController<PagedDataTableEvent> _eventNotifier = StreamController.broadcast();
  final List<BaseTableColumn<T>> _columns;
  final PagedTableRowTapped<T>? _onRowTapped;
  final void Function(T, bool)? _onRowSelected;
  final PagedDataTableFilterState? _filterState;

  late int _pageSize;
  late List<int> _pageSizes;
  late TablePage<T> _currentPage;
  late String _initialPageToken;
  Object? _currentError;
  DateTime? _lastSyncDate;
  Map<T, bool>? _selectedRows;
  bool? _selectedAllRows = false;
  StreamSubscription? _filterUpdatedListener;
  TableState _tableState = TableState.unknown;

  bool get isLoading => _tableState == TableState.loading;
  bool get hasError => _tableState == TableState.error;
  Object get error => _currentError!;
  int get currentPageSize => _pageSize;
  List<int> get pageSizes => UnmodifiableListView(_pageSizes);
  TablePage<T> get currentPage => _currentPage;
  Stream<PagedDataTableEvent> get eventStream => _eventNotifier.stream;
  DateTime? get lastSyncDate => _lastSyncDate; 
  bool get isSelectable => _selectedRows != null;
  Map<T, bool> get selectedRows => _selectedRows!;
  bool? get selectedAllRows => _selectedAllRows;
  List<BaseTableColumn<T>> get columns => UnmodifiableListView(_columns);
  PagedDataTableFilterState? get filterState => _filterState;
  bool get hasFilters => _filterState != null;
  TableState get tableState => _tableState;
  bool get isRowsPerPageAvailable => _pageSizes.isNotEmpty;

  PagedDataTableState({
    required int currentPageSize, 
    required List<int>? pageSizes, 
    required String initialPageToken, 
    required PageResolver<T> pageResolver, 
    required bool isSelectable, 
    required List<BaseTableColumn<T>> columns,
    required PagedTableRowTapped<T>? onRowTapped,
    required void Function(T, bool)? onRowSelected,
    required List<BasePagedDataTableFilter>? filters}) 
    : _pageResolver = pageResolver, 
      _columns = columns,
      _onRowTapped = onRowTapped,
      _onRowSelected = onRowSelected,
      _filterState = filters == null ? null : PagedDataTableFilterState(filters: filters) {
    _pageSize = currentPageSize;
    _pageSizes = pageSizes ?? const [];
    _initialPageToken = initialPageToken;
    _currentPage = TablePage.initial(currentPageToken: initialPageToken);

    if(isSelectable) {
      _selectedRows = {};
    }

    if(hasFilters) {
      _filterUpdatedListener = _filterState!.onFilterUpdated.listen((event) { 
        refresh(clearCache: true, skipCache: true);
      });
    }
  }

  bool isRowSelected(T item) {
    return _selectedRows?[item] ?? false;
  }

  void setRowSelected(T item, bool selected) {
    _selectedRows?[item] = selected;
    _selectedAllRows = null;
    _onRowSelected?.call(item, selected);
    
    notifyListeners();
  }

  void onRowTapped(T item) {
    if(_onRowTapped != null) {
      if(_onRowTapped!.selectRow) {
        setRowSelected(item, !isRowSelected(item));
      }

      if(_onRowTapped!.functions != null && _onRowTapped!.functions!.isNotEmpty) {
        for(var function in _onRowTapped!.functions!) {
          function(item);
        }
      }
    }
  }

  void selectAll(bool? selected) {
    selected ??= false;

    for(var key in _selectedRows!.keys) {
      _selectedRows![key] = selected;
    }

    _selectedAllRows = selected;
    notifyListeners();
  }

  void setPageSize(int pageSize) {
    _pageSize = pageSize;
  }

  Future resolvePage({required TablePageType pageType, required bool skipCache}) async {
    _tableState = TableState.loading;
    notifyListeners();

    String? fetchToken;
    int newPageIndex;
    switch(pageType) {
      case TablePageType.previous:
        fetchToken = _currentPage.previousPageToken;
        newPageIndex = _currentPage.index-1;
        break;

      case TablePageType.current:
        fetchToken = _currentPage.currentPageToken;
        newPageIndex = _currentPage.index;
        break;

      case TablePageType.next:
        fetchToken = _currentPage.nextPageToken;
        newPageIndex = _currentPage.index+1;
        break;
    }

    String? previousPageToken = newPageIndex == 0 ? null : (pageType == TablePageType.current ? _currentPage.previousPageToken : _currentPage.currentPageToken);
    TablePage<T>? newPage;

    try {

      // Try to get from cache first
      newPage = _pageCache[fetchToken];

      // If not found, resolve new page
      if(newPage == null || skipCache) {
        if(pageType == TablePageType.previous) {
          fetchToken = _initialPageToken;
          _pageCache.clear();
          _eventNotifier.add(const DataTableCacheResetEvent(reason: DataTableCacheResetReason.previosPageNotFoundInCache));
        }

        PageIndicator<T> result = await _pageResolver(fetchToken, _pageSize, FilterCollection(
          filters: _filterState == null ? null : {for(var activeFilter in _filterState!.activeFilters) activeFilter.filterId: activeFilter.currentValue}));

        if(result.error != null) {
          throw result.error!;
        }

        // Create new page
        newPage = TablePage<T>(
          currentPageToken: fetchToken, 
          nextPageToken: result.nextPageToken, 
          previousPageToken: previousPageToken, 
          items: result.items, 
          index: newPageIndex
        );

        _pageCache[newPage.currentPageToken!] = newPage;

        debugPrint(newPage.debugPrint());
      }
    } catch(err, stack) {
      debugPrint("An error has ocurred while trying to fetch values from page $fetchToken");
      debugPrint("ERROR: $err");
      debugPrint("STACK: $stack");

      _tableState = TableState.error;
      _currentError = err;
      notifyListeners();
      return;
    }

    _currentPage = newPage;
    _tableState = TableState.displaying;
    _currentError = null;
    _lastSyncDate = DateTime.now();

    if(isSelectable) {
      _selectedRows = { for(var item in newPage.items) item: false };
    }

    try {
      notifyListeners();
    } catch(_) {}
  }

  Future refresh({required bool clearCache, required bool skipCache}) {
    if(clearCache) {
      _pageCache.clear();
      _currentPage = TablePage.initial(currentPageToken: _initialPageToken);
    }

    return resolvePage(pageType: TablePageType.current, skipCache: skipCache);
  }

  void fireEvent(PagedDataTableEvent event) {
    _eventNotifier.add(event);
  }

  @override
  void dispose() {
    _filterUpdatedListener?.cancel();
    _eventNotifier.close();
    super.dispose();
  }
}

class TablePage<T> {
  final String? currentPageToken, nextPageToken, previousPageToken;
  final List<T> items;
  final int index;

  bool get hasNextPage => nextPageToken != null;
  bool get hasPreviousPage => previousPageToken != null;
  bool get isInitial => index == 0;

  TablePage({required this.currentPageToken, required this.nextPageToken, required this.previousPageToken, required this.items, required this.index});

  factory TablePage.initial({required String currentPageToken}) {
    return TablePage(currentPageToken: currentPageToken, previousPageToken: null, nextPageToken: null, items: const [], index: 0);
  }

  String debugPrint() {
    return {
      "currentPageToken": currentPageToken,
      "nextPageToken": nextPageToken,
      "previosPageToken": previousPageToken,
      "index": index
    }.toString();
  }
}

enum TablePageType {
  previous, current, next
}

enum TableState {
  unknown, loading, error, displaying
}