import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BasePagedDataTableFilter<T> {
  final String filterId;
  final T? initialValue;
  final String Function(T selectedItem)? chipFormatter;

  const BasePagedDataTableFilter({required this.filterId, required this.initialValue, required this.chipFormatter});
}

class PagedDataTableTextFieldFilter extends BasePagedDataTableFilter<String> {

  final String? Function(String? text)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String text;
  final InputDecoration? decoration;

  const PagedDataTableTextFieldFilter({
    required String filterId, 
    required this.text,
    required String Function(String selectedItem) chipFormatter,
    this.decoration, 
    this.validator, 
    this.inputFormatters,
    String? initialValue
  }) : super(filterId: filterId, initialValue: initialValue, chipFormatter: chipFormatter);

}

class PagedDataTableDropdownFilter<T> extends BasePagedDataTableFilter<T> {
  
  final String text;
  final List<DropdownMenuItem<T>> items;
  final InputDecoration? decoration;

  PagedDataTableDropdownFilter({
    required String filterId, 
    required this.text, 
    required this.items,
    required String Function(T selectedItem) chipFormatter, 
    this.decoration, 
    T? initialValue}) 
      : super(filterId: filterId, initialValue: initialValue, chipFormatter: chipFormatter);

}