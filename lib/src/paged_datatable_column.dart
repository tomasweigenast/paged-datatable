part of 'paged_datatable.dart';

abstract class BaseTableColumn<TType extends Object> {
  final String? id;
  final String? title;
  final Widget Function(BuildContext context)? titleBuilder;
  final bool sortable;
  final bool isNumeric;
  final double? sizeFactor;

  const BaseTableColumn(
      {required this.id,
      required this.title,
      required this.titleBuilder,
      required this.sortable,
      required this.isNumeric,
      required this.sizeFactor})
      : assert(title != null || titleBuilder != null,
            "Either title or titleBuilder should be provided.");

  Widget buildCell(TType item, int rowIndex);
}

/// Defines a [BaseTableColumn] that allows the content of a cell to be modified, updating the underlying
/// item too.
abstract class EditableTableColumn<TType extends Object, TValue extends Object>
    extends BaseTableColumn<TType> {
  /// Function called when the value of the cell changes, and must update the underlying [TType], returning
  /// true if it could be updated, otherwise, false.
  final Setter<TType, TValue> setter;

  /// A function that returns the value that is going to be edited.
  final Getter<TType, TValue> getter;

  const EditableTableColumn(
      {required this.setter,
      required this.getter,
      required super.id,
      required super.title,
      required super.titleBuilder,
      required super.sortable,
      required super.isNumeric,
      required super.sizeFactor});
}

/// Defines a simple [BaseTableColumn] that renders a cell based on [cellBuilder]
class TableColumn<TType extends Object> extends BaseTableColumn<TType> {
  final Widget Function(TType) cellBuilder;

  const TableColumn(
      {required super.title,
      required this.cellBuilder,
      super.sizeFactor = .1,
      super.isNumeric = false,
      super.sortable = false,
      super.id})
      : assert(!sortable || id != null, "sortable columns must define an id"),
        super(titleBuilder: null);

  @override
  Widget buildCell(TType item, int rowIndex) => cellBuilder(item);
}

/// Defines an [EditableTableColumn] that renders a [DropdownFormField] with a list of items.
class DropdownTableColumn<TType extends Object, TValue extends Object>
    extends EditableTableColumn<TType, TValue> {
  final List<DropdownMenuItem<TValue>> items;
  final InputDecoration? decoration;

  const DropdownTableColumn(
      {this.decoration,
      required this.items,
      required super.getter,
      required super.setter,
      required super.title,
      super.id,
      super.sortable = false,
      super.isNumeric = false,
      super.sizeFactor = .1})
      : super(titleBuilder: null);

  @override
  Widget buildCell(TType item, int rowIndex) {
    return _DropdownButtonCell<TType, TValue>(
      item: item,
      items: items,
      decoration: decoration,
      initialValue: getter(item),
      setter: (newValue) => setter(item, newValue, rowIndex),
    );
  }
}

/// Defines an [EditableTableColumn] that renders a text field when double-clicked
class TextTableColumn<TType extends Object>
    extends EditableTableColumn<TType, String> {
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;

  const TextTableColumn(
      {this.decoration,
      this.inputFormatters,
      required super.getter,
      required super.setter,
      required super.title,
      super.id,
      super.sortable = false,
      super.isNumeric = false,
      super.sizeFactor = .1})
      : super(titleBuilder: null);

  @override
  Widget buildCell(TType item, int rowIndex) {
    return _TextFieldCell<TType>(
      isNumeric: isNumeric,
      item: item,
      inputFormatters: inputFormatters,
      decoration: decoration,
      initialValue: getter(item),
      setter: (newValue) => setter(item, newValue, rowIndex),
    );
  }
}

/// Defines an [EditableTableColumn] that renders the text of a field and when double-clicked, an overlay with a multiline, bigger text field
/// is shown.
class LargeTextTableColumn<TType extends Object>
    extends EditableTableColumn<TType, String> {
  final InputDecoration? decoration;
  final String? label;
  final bool tooltipText;
  final EdgeInsets? tooltipPadding, tooltipMargin;
  final List<TextInputFormatter>? inputFormatters;

  const LargeTextTableColumn(
      {this.decoration,
      this.inputFormatters,
      this.label,
      this.tooltipText = false,
      this.tooltipPadding,
      this.tooltipMargin,
      required super.getter,
      required super.setter,
      required super.title,
      super.id,
      super.sortable = false,
      super.isNumeric = false,
      super.sizeFactor = .1})
      : super(titleBuilder: null);

  @override
  Widget buildCell(TType item, int rowIndex) {
    return _EditableTextField(
        tooltipText: tooltipText,
        tooltipMargin: tooltipMargin,
        tooltipPadding: tooltipPadding,
        initialValue: getter(item) ?? "",
        setter: (newValue) => setter(item, newValue, rowIndex),
        validator: null,
        decoration: decoration,
        label: label ?? title!,
        formatters: inputFormatters);
  }
}
