import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';

final class TableControllerProvider<K extends Comparable<K>, T> extends InheritedWidget {
  final TableController<K, T> controller;

  const TableControllerProvider({required this.controller, required super.child, super.key});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      false; //controller != (oldWidget as TableControllerProvider).controller;

  static TableController<K, T> of<K extends Comparable<K>, T>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TableControllerProvider<K, T>>()!.controller;
}
