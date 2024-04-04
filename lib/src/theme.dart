import 'package:flutter/material.dart';

final class PagedDataTableThemeData {
  final EdgeInsetsGeometry cellPadding;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double elevation;
  final double headerHeight;
  final double footerHeight;
  final double rowHeight;
  final BorderSide borderSide;
  final TextStyle cellTextStyle;
  final TextStyle headerTextStyle;
  final TextStyle footerTextStyle;
  final Color? Function(int index)? cellColor;
  final Color? selectedCellColor;
  final bool verticalScrollbarVisibility;
  final bool horizontalScrollbarVisibility;

  const PagedDataTableThemeData({
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.elevation = 0.0,
    this.borderSide = const BorderSide(color: Color(0xFFD6D6D6), width: 1),
    this.headerHeight = 56.0,
    this.footerHeight = 56.0,
    this.rowHeight = 52.0,
    this.selectedCellColor,
    this.cellTextStyle = const TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis),
    this.headerTextStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
    this.footerTextStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.cellColor,
    this.verticalScrollbarVisibility = true,
    this.horizontalScrollbarVisibility = true,
  });

  @override
  int get hashCode => Object.hash(cellPadding, padding, borderRadius, elevation, headerHeight, footerHeight, rowHeight,
      borderSide, cellTextStyle, headerTextStyle, cellColor, verticalScrollbarVisibility, horizontalScrollbarVisibility);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is PagedDataTableThemeData &&
          other.cellPadding == cellPadding &&
          other.padding == padding &&
          other.borderRadius == borderRadius &&
          other.elevation == elevation &&
          other.headerHeight == headerHeight &&
          other.footerHeight == footerHeight &&
          other.rowHeight == rowHeight &&
          other.borderSide == borderSide &&
          other.cellTextStyle == cellTextStyle &&
          other.headerTextStyle == headerTextStyle &&
          other.cellColor == cellColor &&
          other.selectedCellColor == selectedCellColor &&
          other.verticalScrollbarVisibility == verticalScrollbarVisibility &&
          other.horizontalScrollbarVisibility == horizontalScrollbarVisibility);
}

final class PagedDataTableTheme extends InheritedWidget {
  final PagedDataTableThemeData data;

  const PagedDataTableTheme({required this.data, required super.child, super.key});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => data != (oldWidget as PagedDataTableTheme).data;

  /// Lookups for a [PagedDataTableTheme] widget in the widget tree, if not found, returns null.
  static PagedDataTableThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PagedDataTableTheme>()?.data;

  /// Lookups for a [PagedDataTableTheme] widget in the widget tree, if not found, then default [PagedDataTableThemeData] is returned.
  static PagedDataTableThemeData of(BuildContext context) => maybeOf(context) ?? const PagedDataTableThemeData();
}
