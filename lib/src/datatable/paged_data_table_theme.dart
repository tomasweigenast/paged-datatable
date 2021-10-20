import 'package:flutter/material.dart';

class PagedDataTableTheme {
  /// A custom theme to apply to any [EditableTableColumn]
  final EditableColumnTheme? editableColumnTheme;

  /// The list of background colors to apply to the rows. 
  /// If this list contains a single color, it is set to all rows across the table.
  /// If two colors are in this list, rows will alternate between those two colors.
  /// 
  /// NOTE: More than two colors is not supported at this time.
  final List<Color>? rowColors;

  /// Header theme data
  final PagedDataTableHeaderTheme? headerTheme;

  /// Footer theme data
  final PagedDataTableFooterTheme? footerTheme;

  /// Shorthand access to [PagedDataTableHeaderTheme.backgroundColor] and [PagedDataTableFooterTheme.backgroundColor]
  final Color? backgroundColor;

  /// Shorthand access to [PagedDataTableHeaderTheme.columnNameColor] and [PagedDataTableFooterTheme.textColor]
  final Color? textColor;

  /// The color of the row when its selected
  final Color? selectedRowColor;

  /// The shape of the entire table.
  final ShapeBorder? shape;

  /// A widget that is shown when an error is caught.
  final Widget Function(BuildContext context, Object? error)? onErrorBuilder; 

  /// A widget that is shown when no items are found.
  final Widget Function(BuildContext context)? onNoItemsFound;

  const PagedDataTableTheme({
    this.editableColumnTheme,
    this.rowColors,
    this.headerTheme,
    this.footerTheme,
    this.backgroundColor,
    this.textColor,
    this.selectedRowColor,
    this.onErrorBuilder,
    this.onNoItemsFound,
    this.shape}) : 
      assert(textColor == null || (headerTheme == null || footerTheme == null), "Cannot provide both textColor and headerTheme or footerTheme"),
      assert(backgroundColor == null || (headerTheme == null || footerTheme == null), "Cannot provide both textColor and headerTheme or footerTheme");

  factory PagedDataTableTheme.fromThemeData(ThemeData themeData) {
    return PagedDataTableTheme(
      footerTheme: PagedDataTableFooterTheme(
        paginationButtonsColor: themeData.colorScheme.primary
      )
    );
  }
}

class EditableColumnTheme {
  final ButtonStyle? saveButtonStyle;
  final ButtonStyle? cancelButtonStyle;
  final bool obscureBackground;

  const EditableColumnTheme({this.saveButtonStyle, this.cancelButtonStyle, this.obscureBackground = true});
}

/// Theme data apply to [PagedDataTable]'s headers
class PagedDataTableHeaderTheme {
  final Color? backgroundColor;
  final Color? columnNameColor;

  const PagedDataTableHeaderTheme({this.backgroundColor, this.columnNameColor});
}

/// Theme data apply to [PagedDataTable]'s footers
class PagedDataTableFooterTheme {
  final Color? backgroundColor;
  final Color? textColor;

  /// The color of the pagination buttons.
  final Color? paginationButtonsColor;

  /// A custom [InputDecoration] applied to the Rows per Page dropdown
  final InputDecoration? rowsPerPageDropdownInputDecoration;

  const PagedDataTableFooterTheme({this.backgroundColor, this.textColor, this.paginationButtonsColor, this.rowsPerPageDropdownInputDecoration});
}