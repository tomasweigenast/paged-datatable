part of 'paged_datatable.dart';

class PagedDataTableRowState extends ChangeNotifier {
  final int rowIndex;
  bool _isSelected = false;
  set selected(bool newValue) {
    _isSelected = newValue;
    notifyListeners();
  }

  PagedDataTableRowState(this.rowIndex);

}