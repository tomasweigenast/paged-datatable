import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';

class PagedDataTableTextFilter extends BasePagedDataTableFilter<String> {

  final InputDecoration? inputDecoration;
  final String text;

  PagedDataTableTextFilter({
    required this.text,
    required String filterId,
    required ChipFormatterFunc<String> chipFormatter,
    String? initialValue,
    this.inputDecoration})
      : super(filterId: filterId, initialValue: initialValue, chipFormatter: chipFormatter);

  @override
  Widget render(BuildContext context, String? currentValue, FilterValueNotifier<String> notifyValue) {
    return TextFormField(
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
      initialValue: currentValue,
      autofocus: false,
      autovalidateMode: AutovalidateMode.disabled,
      onSaved: (fieldText) {
        if(fieldText != null && fieldText.isNotEmpty) {
          notifyValue(fieldText);
        }
      },
    );
  }

}