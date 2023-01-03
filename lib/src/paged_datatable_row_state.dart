part of 'paged_datatable.dart';

class _PagedDataTableRowState<TResult extends Object> extends ChangeNotifier {
  final TResult item;
  final int rowIndex;
  bool _isSelected = false;
  set selected(bool newValue) {
    _isSelected = newValue;
    notifyListeners();
  }

  _PagedDataTableRowState(this.item, this.rowIndex);

  void refresh() {
    notifyListeners();
  }
}
