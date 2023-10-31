part of 'paged_datatable.dart';

/// The default [PagedDataTableThemeData] created to follow the Material 3 conventions.
const _kDefaultPagedDataTableTheme = PagedDataTableThemeData();

class PagedDataTableTheme extends InheritedWidget {
  final PagedDataTableThemeData data;

  const PagedDataTableTheme(
      {required this.data, required super.child, super.key});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      data != (oldWidget as PagedDataTableTheme).data;

  static PagedDataTableThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PagedDataTableTheme>()
        ?.data;
  }

  /// Lookups for a [PagedDataTableTheme] widget in the widget tree, if not found, then default [PagedDataTableThemeData] is returned.
  static PagedDataTableThemeData of(BuildContext context) {
    return maybeOf(context) ?? _kDefaultPagedDataTableTheme;
  }
}

class PagedDataTableThemeData extends Equatable {
  /// The [PagedDataTableConfiguration] data.
  final PagedDataTableConfiguration configuration;

  /// The background color of the entire table.
  ///
  /// Defaults to [Colors.white]
  final Color backgroundColor;

  /// The color of the header row.
  ///
  /// Defaults to [backgroundColor]
  final Color? headerBackgroundColor;

  /// The color of the filters header row.
  ///
  /// Defalts to [backgroundColor]
  final Color? filtersHeaderBackgroundColor;

  /// The color of the footer row.
  ///
  /// Defaults to [backgroundColor].
  final Color? footerBackgroundColor;

  /// The list of colors to iterate between them when rendering rows.
  /// The list must contain exactly two elements. To disable this, set to null.
  ///
  /// Defaults to [backgroundColor]
  final List<Color>? rowColors;

  /// The [TextStyle] for the entire table.
  ///
  /// Defaults to a [TextStyle] with a [Colors.black] color.
  final TextStyle textStyle;

  /// The [TextStyle] for each row.
  ///
  /// Defaults to a [TextStyle] with a 14 font size.
  final TextStyle rowsTextStyle;

  /// The [TextStyle] for the header row.
  ///
  /// Defaults to [textStyle].
  final TextStyle? headerTextStyle;

  /// The [TextStyle] for the filters header row.
  ///
  /// Defaults to [textStyle].
  final TextStyle? filtersHeaderTextStyle;

  /// The [TextStyle] for the footer row.
  ///
  /// Defaults to [textStyle].
  final TextStyle? footerTextStyle;

  /// The theme applied to filter chips.
  ///
  /// Defaults to platform theme.
  final ChipThemeData? chipTheme;

  /// The border of the table.
  ///
  /// Defaults to a [RoundedRectangleBorder] with a circular [BorderRadius] of radius 4,
  /// and a [BorderSide] with a [Color(0xffDADCE0)] color.
  final ShapeBorder? border;

  /// The color of the divider row.
  ///
  /// Defaults to platform color.
  final Color? dividerColor;

  /// The color of every button in the table.
  ///
  /// Defaults to platform color.
  final Color? buttonsColor;

  const PagedDataTableThemeData(
      {this.configuration = const PagedDataTableConfiguration(),
      this.backgroundColor = Colors.white,
      this.headerBackgroundColor,
      this.filtersHeaderBackgroundColor,
      this.footerBackgroundColor,
      this.footerTextStyle,
      this.textStyle = const TextStyle(color: Colors.black),
      this.rowsTextStyle = const TextStyle(fontSize: 14),
      this.headerTextStyle =
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      this.filtersHeaderTextStyle,
      this.rowColors,
      this.chipTheme,
      this.dividerColor,
      this.buttonsColor,
      this.border = const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          side: BorderSide(color: Color(0xffDADCE0)))});

  @override
  List<Object?> get props => [configuration, backgroundColor];
}

class PagedDataTableConfiguration extends Equatable {
  /// A flag that indicates if the current dataset of the table can be refreshed.
  /// A refresh button will be rendered.
  final bool allowRefresh;

  /// The list of available page sizes the user can select.
  /// Set it to null to disable user-selected page size.
  final List<int>? pageSizes;

  /// The initial page size. If [pageSizes] is not null, [initialPageSize] must match
  /// any of the values in the list.
  final int initialPageSize;

  /// The height of the columns header
  ///
  /// Defaults to 56.
  final double columnsHeaderHeight;

  /// The height of every row. If null, it will size to content.
  ///
  /// Defaults to 52.
  final double? rowHeight;

  /// The height of the filter bar.
  ///
  /// Defaults to 56
  final double filterBarHeight;

  /// Configuration related to the footer of the table.
  final PagedDataTableFooterConfiguration footer;

  const PagedDataTableConfiguration(
      {this.allowRefresh = true,
      this.pageSizes = const [10, 20, 50, 100],
      this.columnsHeaderHeight = 56.0,
      this.filterBarHeight = 56.0,
      this.rowHeight = 52.0,
      this.initialPageSize = 100,
      this.footer = const PagedDataTableFooterConfiguration()});

  @override
  List<Object?> get props => [
        allowRefresh,
        pageSizes,
        columnsHeaderHeight,
        filterBarHeight,
        rowHeight,
        initialPageSize,
        footer
      ];
}

class PagedDataTableFooterConfiguration extends Equatable {
  /// If true, the footer will show the current total elements of the table, otherwise, it will show
  /// the current page's index.
  ///
  /// Defaults to false.
  final bool showTotalElements;

  /// A flag that indicates if the footer should be visible.
  ///
  /// Defaults to true.
  final bool footerVisible;

  const PagedDataTableFooterConfiguration(
      {this.showTotalElements = false, this.footerVisible = true});

  @override
  List<Object?> get props => [showTotalElements];
}
