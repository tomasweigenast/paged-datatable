part of 'paged_datatable.dart';

class _PagedDataTableRowState<TResultId extends Comparable, TResult extends Object>
    extends ChangeNotifier {
  final TResult item;
  final int index;
  final ModelIdGetter<TResultId, TResult> idGetter;

  TResultId? _itemId;

  bool _isSelected = false;
  set selected(bool newValue) {
    _isSelected = newValue;
    notifyListeners();
  }

  TResultId get itemId => _itemId ??= idGetter(item);

  _PagedDataTableRowState(this.index, this.item, this.idGetter);

  void refresh() {
    notifyListeners();
  }
}
