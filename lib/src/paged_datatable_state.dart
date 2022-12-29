part of 'paged_datatable.dart';

class _PagedDataTableState<TKey extends Object, TResult extends Object> extends ChangeNotifier {
  int _pageSize = 100;
  _TableState _state = _TableState.loading;
  
  final PagedDataTableController<TKey, TResult> controller;
  final FetchCallback<TKey, TResult> fetchCallback;
  final TKey initialPage;
  final Size viewSize;
  final List<TableColumn<TResult>> columns;
  final List<TResult> currentItems = [];

  _TableState get state => _state;

  _PagedDataTableState({
    required this.fetchCallback,
    required this.initialPage,
    required this.viewSize,
    required this.columns,
    PagedDataTableController<TKey, TResult>? controller
  }) : 
    controller = controller ?? PagedDataTableController() {
      _dispatchCallback();
    }

  void setPageSize(int pageSize) {
    _pageSize = pageSize;
    notifyListeners();
    _dispatchCallback();
  }

  Future<void> _dispatchCallback() async {
    _state = _TableState.loading;
    try {
      var pageIndicator = await fetchCallback(initialPage, _pageSize);
      currentItems.clear();
      currentItems.addAll(pageIndicator.elements);
      notifyListeners();
      _state = _TableState.displaying;
    } catch(err, stack) {
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