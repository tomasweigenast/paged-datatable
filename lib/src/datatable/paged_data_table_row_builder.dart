import 'package:flutter/cupertino.dart';
import 'package:paged_datatable/paged_datatable.dart';

class PagedDataTableRowBuilder<T> {
  final bool Function(BuildContext context, T item)? enabledWhen;
  final Widget Function(BuildContext context, T item) builder;

  PagedDataTableRowBuilder({required this.builder, this.enabledWhen});
}