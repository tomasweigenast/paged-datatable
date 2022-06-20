import 'package:flutter/material.dart';

typedef ChipFormatterFunc<T> = String Function(T selectedItem);
typedef FilterValueNotifier<T> = void Function(T? newValue);

abstract class BasePagedDataTableFilter<T> {
  final String filterId;
  final T? initialValue;
  final ChipFormatterFunc<T> chipFormatter;

  BasePagedDataTableFilter({required this.filterId, required this.chipFormatter, this.initialValue});

  Widget render(BuildContext context, T? currentValue, FilterValueNotifier<T> notifyValue);
}