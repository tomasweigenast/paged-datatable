import 'package:flutter/material.dart';

final class PagedDataTableThemeData {
  /// The padding of the cell.
  final EdgeInsetsGeometry cellPadding;

  /// The padding of a entire column, from other columns.
  final EdgeInsetsGeometry padding;

  /// The [BorderRadius] of the table.
  final BorderRadius borderRadius;

  /// The elevation of the table.
  final double elevation;

  /// The header bar's height
  final double headerHeight;

  /// The footer bar's height
  final double footerHeight;

  /// The height of each row.
  final double rowHeight;

  /// The filter bar's height.
  final double filterBarHeight;

  /// The [BoxBorder] to render for each cell.
  final BoxBorder cellBorderSide;

  /// The [TextStyle] for [Text]-like elements of a cell.
  final TextStyle cellTextStyle;

  /// The [TextStyle] for [Text]-like elements in the header.
  final TextStyle headerTextStyle;

  /// The [TextStyle] for [Text]-like elements in the footer.
  final TextStyle footerTextStyle;

  /// A function that calculates the [Color] of a row.
  final Color? Function(int index)? rowColor;

  /// The [Color] of a selected row.
  final Color? selectedRow;

  /// A flag that indicates if the vertical scrollbar should be visible.
  final bool verticalScrollbarVisibility;

  /// A flag that indicates if the horizontal scrollbar should be visible.
  final bool horizontalScrollbarVisibility;

  /// The width breakpoint that [PagedDataTable] uses to decide if will render a popup or a bottom sheet when the filter dialog is requested.
  final double filterDialogBreakpoint;

  const PagedDataTableThemeData({
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.elevation = 0.0,
    this.cellBorderSide = const Border(),
    this.headerHeight = 56.0,
    this.footerHeight = 56.0,
    this.filterBarHeight = 50.0,
    this.rowHeight = 52.0,
    this.selectedRow,
    this.cellTextStyle = const TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis),
    this.headerTextStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
    this.footerTextStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.rowColor,
    this.verticalScrollbarVisibility = true,
    this.horizontalScrollbarVisibility = true,
    this.filterDialogBreakpoint = 1000.0,
  });

  @override
  int get hashCode => Object.hash(cellPadding, padding, borderRadius, elevation, headerHeight, footerHeight, rowHeight,
      cellBorderSide, cellTextStyle, headerTextStyle, rowColor, verticalScrollbarVisibility, horizontalScrollbarVisibility);

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
          other.cellTextStyle == cellTextStyle &&
          other.headerTextStyle == headerTextStyle &&
          other.rowColor == rowColor &&
          other.cellBorderSide == cellBorderSide &&
          other.selectedRow == selectedRow &&
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
