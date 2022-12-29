part of 'paged_datatable.dart';

class TableColumn<TResult extends Object> {
  final String? id;
  final String title;
  final Widget Function(TResult) itemBuilder;
  final double sizeFactor;
  final bool isNumeric;
  final bool sortable;
  
  const TableColumn({
    required this.title, 
    required this.itemBuilder, 
    this.sizeFactor = .1, 
    this.isNumeric = false,
    this.sortable = false,
    this.id
  }) : assert(!sortable || id != null, "sortable columns must define an id");

}