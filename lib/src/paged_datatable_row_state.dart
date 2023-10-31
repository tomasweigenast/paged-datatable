part of 'paged_datatable.dart';

class _PagedDataTableRowState<TResultId extends Comparable,
    TResult extends Object> extends ChangeNotifier {
  final TResult item;
  final TResultId itemId;
  final int index;

  bool _isSelected = false;
  set selected(bool newValue) {
    _isSelected = newValue;
    notifyListeners();
  }

  _PagedDataTableRowState(this.index, this.item, this.itemId);

  void refresh() {
    notifyListeners();
  }
}
