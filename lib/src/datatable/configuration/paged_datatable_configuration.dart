import 'package:flutter/material.dart';
import 'package:paged_datatable/src/datatable/configuration/paged_datatable_configuration_data.dart';

class PagedDataTableConfiguration extends InheritedWidget {
  final PagedDataTableConfigurationData data;

  const PagedDataTableConfiguration({required this.data, required Widget child, Key? key}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(PagedDataTableConfiguration oldWidget) => oldWidget.data != data;

  static PagedDataTableConfigurationData? maybeOf(BuildContext context) {
    try {
      return context.dependOnInheritedWidgetOfExactType<PagedDataTableConfiguration>()?.data;
    } catch(err) {
      return null;
    }
  }
}