import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';

class PagedDataTableDropdownFilter<T> extends BasePagedDataTableFilter<T> {

  final InputDecoration? inputDecoration;
  final String text;
  final List<DropdownMenuItem<T>> items;

  PagedDataTableDropdownFilter({
    required this.text,
    required this.items,
    required String filterId,
    required ChipFormatterFunc<T> chipFormatter,
    T? initialValue,
    this.inputDecoration})
      : super(filterId: filterId, initialValue: initialValue, chipFormatter: chipFormatter);

  @override
  Widget render(BuildContext context, T? currentValue, FilterValueNotifier<T> notifyValue) {
    return DropdownButtonFormField<dynamic>(
      items: items,
      isExpanded: false,
      value: currentValue,
      decoration: InputDecoration(
        labelText: text,
        hintText: inputDecoration?.hintText,
        border: inputDecoration?.border,
        contentPadding: inputDecoration?.contentPadding,
        helperText: inputDecoration?.helperText,
        suffix: inputDecoration?.suffix,
        suffixIcon: inputDecoration?.suffixIcon,
        suffixStyle: inputDecoration?.suffixStyle,
        suffixText: inputDecoration?.suffixText,
        prefix: inputDecoration?.prefix,
        prefixIcon: inputDecoration?.prefixIcon,
        prefixStyle: inputDecoration?.prefixStyle,
        prefixText: inputDecoration?.prefixText,
        isDense: true
      ),
      autofocus: false,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: (newValue) {
        notifyValue(newValue);
      },
    );
  }

}