part of 'paged_datatable.dart';

typedef Setter<T, V> = FutureOr<bool> Function(T item, V value, int rowIndex);
typedef Getter<T, V> = V? Function(T item, int rowIndex);
typedef CellBuilder<T> = Widget Function(BuildContext context, T item, int rowIndex);

/// [ReadOnlyTableColumn] represents a basic table column for [T] that displays read-only content.
sealed class ReadOnlyTableColumn<K extends Comparable<K>, T> {
  /// The title of the column.
  final Widget title;

  /// The tooltip to show in the column's header. If null, it will try to take the content of [title], if it's a Text, otherwise, it won't show a tooltip.
  final String? tooltip;

  /// The id of the column. Useful if this column can be used to sort data.
  final String? id;

  /// The size of the column
  final ColumnSize size;

  /// The column's format
  final ColumnFormat format;

  /// A flag that indicates if the column can be used as sort model. [id] must not be null.
  final bool sortable;

  const ReadOnlyTableColumn({
    required this.id,
    required this.title,
    required this.size,
    required this.format,
    required this.tooltip,
    required this.sortable,
  }) : assert(sortable ? id != null : true, "When column is sortable, id must be set.");

  /// Builds the cell for [item] at [index].
  Widget build(BuildContext context, T item, int index);

  @override
  int get hashCode => Object.hash(id, size, title, format);

  @override
  bool operator ==(Object other) =>
      other is ReadOnlyTableColumn<K, T> &&
      other.title == title &&
      other.id == id &&
      other.size == size &&
      other.format == format;
}

/// [EditableTableColumn] represents a basic table column for [T] that display editable content of type [V].
sealed class EditableTableColumn<K extends Comparable<K>, T, V> extends ReadOnlyTableColumn<K, T> {
  /// The function that is going to be called when the field is saved. It must return a boolean indicating
  /// if the update operation succeeded or not, being [true] for a successful operation or false otherwise.
  final Setter<T, V> setter;

  /// The function that is going to retrieve the current value of [T] for this column.
  final Getter<T, V> getter;

  const EditableTableColumn({
    required super.id,
    required super.title,
    required super.size,
    required super.format,
    required super.tooltip,
    required super.sortable,
    required this.setter,
    required this.getter,
  });
}

/// [TableColumn] is a implementation of [ReadOnlyTableColumn] that renders a cell based on [cellBuilder].
final class TableColumn<K extends Comparable<K>, T> extends ReadOnlyTableColumn<K, T> {
  final CellBuilder<T> cellBuilder;

  const TableColumn({
    required this.cellBuilder,
    required super.title,
    super.id,
    super.size = const FractionalColumnSize(.1),
    super.format = const AlignColumnFormat(alignment: Alignment.centerLeft),
    super.tooltip,
    super.sortable = false,
  });

  @override
  Widget build(BuildContext context, T item, int index) => cellBuilder(context, item, index);

  @override
  int get hashCode => Object.hash(id, size, title, cellBuilder, format);

  @override
  bool operator ==(Object other) =>
      other is TableColumn<K, T> &&
      other.cellBuilder == cellBuilder && // todo: this will always return false, fix a better way to compare those
      other.title == title &&
      other.id == id &&
      other.size == size &&
      other.format == format;
}

/// [DropdownTableColumn] renders a compact [DropdownButton] that allows to modify the cell's value in place.
///
/// The [DropdownButton]'s type is [V].
final class DropdownTableColumn<K extends Comparable<K>, T, V> extends EditableTableColumn<K, T, V> {
  final InputDecoration inputDecoration;
  final List<DropdownMenuItem<V>> items;

  const DropdownTableColumn({
    required super.title,
    super.id,
    super.size = const FractionalColumnSize(.1),
    super.format = const AlignColumnFormat(alignment: Alignment.centerLeft),
    super.tooltip,
    super.sortable = false,
    required super.setter,
    required super.getter,
    required this.items,
    this.inputDecoration = const InputDecoration(isDense: true),
  });

  @override
  Widget build(BuildContext context, T item, int index) => _DropdownCell<T, V>(
        getter: getter,
        setter: setter,
        index: index,
        item: item,
        items: items,
        inputDecoration: inputDecoration,
        key: ValueKey(item),
      );
}

/// [TextTableColumn] renders a compact [TextField] that allows to modify the cell's value in place when double-clicked.
final class TextTableColumn<K extends Comparable<K>, T> extends EditableTableColumn<K, T, String> {
  final InputDecoration inputDecoration;
  final List<TextInputFormatter>? inputFormatters;

  const TextTableColumn({
    required super.title,
    super.id,
    super.size = const FractionalColumnSize(.1),
    super.format = const AlignColumnFormat(alignment: Alignment.centerLeft),
    super.tooltip,
    super.sortable = false,
    required super.setter,
    required super.getter,
    this.inputDecoration = const InputDecoration(isDense: true),
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context, T item, int index) => _TextFieldCell<T>(
        getter: getter,
        setter: setter,
        index: index,
        item: item,
        key: ValueKey(item),
        isDialog: false,
        inputDecoration: inputDecoration,
        inputFormatters: inputFormatters,
      );
}

/// [LargeTextTableColumn] renders an overlay dialog with a [TextField] that allows to modify the cell's value when double-clicked.
///
/// This works better for cells with large content.
final class LargeTextTableColumn<K extends Comparable<K>, T> extends EditableTableColumn<K, T, String> {
  final InputDecoration inputDecoration;
  final List<TextInputFormatter>? inputFormatters;

  /// A flag that indicates if the cell should display a tooltip of the whole cell's content.
  final bool showTooltip;

  /// The text's validator.
  final FormFieldValidator? validator;

  /// The overlay field's label.
  final String fieldLabel;

  /// The tooltip's text style.
  final TextStyle tooltipStyle;

  /// The [BoxConstraints] where to render the tooltip.
  final BoxConstraints? tooltipConstraints;

  /// The width breakpoint that [PagedDataTable] uses to decide if will render an overlay or a bottom sheet when the field is edited.
  final double bottomSheetBreakpoint;

  const LargeTextTableColumn({
    required super.title,
    super.id,
    super.size = const FractionalColumnSize(.1),
    super.format = const AlignColumnFormat(alignment: Alignment.centerLeft),
    super.tooltip,
    super.sortable = false,
    required super.setter,
    required super.getter,
    required this.fieldLabel,
    this.inputDecoration = const InputDecoration(isDense: true, border: OutlineInputBorder()),
    this.inputFormatters,
    this.validator,
    this.showTooltip = true,
    this.tooltipStyle = const TextStyle(color: Colors.white),
    this.tooltipConstraints,
    this.bottomSheetBreakpoint = 1000,
  });

  @override
  Widget build(BuildContext context, T item, int index) => _LargeTextFieldCell<T>(
        getter: getter,
        setter: setter,
        index: index,
        item: item,
        key: ValueKey(item),
        isDialog: false,
        inputDecoration: inputDecoration,
        inputFormatters: inputFormatters,
        label: fieldLabel,
        tooltipText: showTooltip,
        validator: validator,
        tooltipStyle: tooltipStyle,
        tooltipConstraints: tooltipConstraints,
        bottomSheetBreakpoint: bottomSheetBreakpoint,
      );
}

/// A special [ReadOnlyTableColumn] that renders a checkbox used to select rows.
final class RowSelectorColumn<K extends Comparable<K>, T> extends ReadOnlyTableColumn<K, T> {
  /// Creates a new [RowSelectorColumn].
  RowSelectorColumn()
      : super(
          format: const AlignColumnFormat(alignment: Alignment.center),
          id: null,
          size: const FixedColumnSize(80),
          sortable: false,
          tooltip: "Select rows",
          title: _SelectAllRowsCheckbox<K, T>(),
        );

  @override
  Widget build(BuildContext context, T item, int index) {
    return _SelectRowCheckbox<K, T>(index: index);
  }
}
