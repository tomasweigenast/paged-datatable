import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/datatable/column/dropdown_table_column.dart';
import 'package:paged_datatable/src/datatable/column/editable_text_field.dart';

class BaseTableColumn<T> {
  final int? flex;
  final Alignment? alignment;
  final Widget title;

  const BaseTableColumn({required this.flex, required this.alignment, required this.title});
}

class TableColumn<T> extends BaseTableColumn<T> {
  final Widget Function(BuildContext context, T item) rowFormatter;

  TableColumn({required String title, required this.rowFormatter, int? flex, Alignment? alignment}) 
    : super(title: Tooltip(child: SelectableText(title), message: title,), flex: alignment == null ? flex ?? 1 : null, alignment: alignment);
}

class EditableTableColumn<T> extends TableColumn<T> {
  EditableTableColumn({
    required String title, 
    required Future Function(T value, String newText) onChange, 
    required String Function(T value) valueFormatter,
    bool multiline = false,
    InputDecoration? decoration,
    String? Function(String? text)? validator,
    List<TextInputFormatter>? textFormatters,
    int? flex, 
    Alignment? alignment,
  }) 
    : super(
        title: title, 
        flex: alignment == null ? flex ?? 1 : null, 
        alignment: alignment,
        rowFormatter: (context, value) {
          return EditableTextField(
            onChange: (text) => onChange(value, text),
            theme: PagedDataTableConfiguration.maybeOf(context)?.theme?.editableColumnTheme,
            initialValue: valueFormatter(value),
            validator: validator,
            decoration: decoration,
            multiline: multiline,
            label: title,
            formatters: textFormatters,
            key: ValueKey(value),
          );
        }
      );
}

class DropdownTableColumn<TableType, ItemType> extends TableColumn<TableType> {
  DropdownTableColumn({
    required String title, 
    required Future Function(TableType item, ItemType newValue) onChange, 
    required String Function(ItemType value) valueFormatter,
    required List<ItemType> items,
    required ItemType Function(TableType value) forField,
    int? flex, 
    Alignment? alignment,
  }) 
    : super(
        title: title, 
        flex: alignment == null ? flex ?? 1 : null, 
        alignment: alignment,
        rowFormatter: (context, value) {
          return DropdownTableColumnWidget<ItemType>(
            onChange: (newValue) => onChange(value, newValue),
            valueFormatter: valueFormatter,
            items: items,
            initialValue: forField(value),
            // label: title,
            key: ValueKey(value),
          );
        }
      );
}

class CheckboxTableColumn<T> extends BaseTableColumn<T> {
  final Future Function(T item, bool newValue)? onChange;
  final bool Function(T item) forField;

  CheckboxTableColumn({required String title, required this.forField, this.onChange, int? flex, Alignment? alignment}) 
    : super(title: Tooltip(child: SelectableText(title), message: title), flex: alignment == null ? flex ?? 1 : null, alignment: alignment);
}

class TableColumnBuilder<T> extends BaseTableColumn<T> {
  final Widget Function(BuildContext context, T item) rowFormatter;

  TableColumnBuilder({required Widget title, required this.rowFormatter, int? flex, Alignment? alignment}) 
    : super(title: title, flex: alignment == null ? flex ?? 1 : null, alignment: alignment);
}