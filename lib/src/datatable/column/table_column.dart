import 'package:flutter/material.dart';

class BaseTableColumn<T> {
  final int? flex;
  final Alignment? alignment;
  final Widget title;

  const BaseTableColumn({required this.flex, required this.alignment, required this.title});
}

class TableColumn<T> extends BaseTableColumn<T> {
  final Widget Function(BuildContext context, T item) rowFormatter;

  TableColumn({required String title, required this.rowFormatter, int? flex, Alignment? alignment}) 
    : super(title: SelectableText(title), flex: alignment == null ? flex ?? 1 : null, alignment: alignment);
}

class CheckboxTableColumn<T> extends BaseTableColumn<T> {
  final Future Function(bool newValue)? onChange;
  final bool Function(T item) forField;

  CheckboxTableColumn({required String title, required this.forField, this.onChange, int? flex, Alignment? alignment}) 
    : super(title: SelectableText(title), flex: alignment == null ? flex ?? 1 : null, alignment: alignment);
}

class TableColumnBuilder<T> extends BaseTableColumn<T> {
  final Widget Function(BuildContext context, T item) rowFormatter;

  TableColumnBuilder({required Widget title, required this.rowFormatter, int? flex, Alignment? alignment}) 
    : super(title: title, flex: alignment == null ? flex ?? 1 : null, alignment: alignment);
}