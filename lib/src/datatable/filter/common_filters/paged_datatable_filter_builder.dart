import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';

class PagedDataTableFilterBuilder<T> extends BasePagedDataTableFilter<T> {

  final InputDecoration? inputDecoration;
  final Widget Function(BuildContext context, T? currentValue, FilterValueNotifier<T> notifyValue) builder;

  PagedDataTableFilterBuilder({
    required String filterId,
    required ChipFormatterFunc<T> chipFormatter,
    required this.builder,
    T? initialValue,
    this.inputDecoration})
      : super(filterId: filterId, initialValue: initialValue, chipFormatter: chipFormatter);

  @override
  Widget render(BuildContext context, T? currentValue, FilterValueNotifier<T> notifyValue) {
    return builder(context, currentValue, notifyValue);
  }

}