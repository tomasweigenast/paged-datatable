part of 'paged_datatable.dart';

abstract class BaseTableColumn<TType extends Object> {
  final String? id;
  final String title;
  final bool sortable;
  final bool isNumeric;
  final double sizeFactor;

  const BaseTableColumn({
    required this.id,
    required this.title, 
    required this.sortable, 
    required this.isNumeric,
    required this.sizeFactor
  });

  Widget _buildCell(TType item);
}

/// Defines a simple [BaseTableColumn] that renders a cell based on [cellBuilder]
class TableColumn<TType extends Object> extends BaseTableColumn<TType> {
  final Widget Function(TType) cellBuilder;
  
  const TableColumn({
    required super.title, 
    required this.cellBuilder, 
    super.sizeFactor = .1, 
    super.isNumeric = false,
    super.sortable = false,
    super.id
  }) : assert(!sortable || id != null, "sortable columns must define an id");
  
  @override
  Widget _buildCell(TType item) => cellBuilder(item);
}

/// Defines a [BaseTableColumn] that allows the content of a cell to be modified, updating the underlying
/// item too.
abstract class EditableTableColumn<TType extends Object> extends BaseTableColumn<TType> {
  const EditableTableColumn({
    required super.id, 
    required super.title, 
    required super.sortable, 
    required super.isNumeric, 
    required super.sizeFactor
  });

  @override
  Widget _buildCell(TType item) {
    return _cellBuilder(item, (item) {
      // TODO: implement
    });
  }

  Widget _cellBuilder(TType item, void Function(TType) changeNotifier);
}


class DropdownTableColumn<TType extends Object, TValue> extends EditableTableColumn<TType> {
  final List<DropdownMenuItem<TValue>> items;

  const DropdownTableColumn({
    required this.items,
    required super.id, 
    required super.title, 
    required super.sortable, 
    required super.isNumeric, 
    required super.sizeFactor
  });

  @override
  Widget _buildCell(TType item) {
    return Container();
  }
  
  @override
  Widget _cellBuilder(TType item, void Function(TType p1) changeNotifier) {
    // return 
    return Container();
  }

}