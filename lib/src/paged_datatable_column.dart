part of 'paged_datatable.dart';

class TableColumn<TResult extends Object> {
  final String title;
  final Widget Function(TResult) itemBuilder;
  final double sizeFactor;
  final bool isNumeric;
  
  const TableColumn({required this.title, required this.itemBuilder, this.sizeFactor = .1, this.isNumeric = false});

}