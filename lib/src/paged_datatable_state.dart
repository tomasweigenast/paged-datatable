part of 'paged_datatable.dart';

class _PagedDataTableState<TKey extends Object, TResult extends Object> extends ChangeNotifier {
  final PagedDataTableController<TKey, TResult> controller;
  final FetchCallback<TKey, TResult> fetchCallback;
  final TKey initialPage;
  final Size viewSize;
  final List<TableColumn<TResult>> columns;
  final List<TResult> currentItems = [];

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

  Future<void> _dispatchCallback() async {
    var pageIndicator = await fetchCallback(initialPage);
    currentItems.clear();
    currentItems.addAll(pageIndicator.elements);
    notifyListeners();
  }
}