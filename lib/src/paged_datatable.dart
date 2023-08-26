import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:paged_datatable/l10n/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:equatable/equatable.dart';

part 'controls.dart';
part 'errors.dart';
part 'paged_datatable_column.dart';
part 'paged_datatable_column_header.dart';
part 'paged_datatable_controller.dart';
part 'paged_datatable_filter.dart';
part 'paged_datatable_filter_bar.dart';
part 'paged_datatable_filter_bar_menu.dart';
part 'paged_datatable_footer.dart';
part 'paged_datatable_menu.dart';
part 'paged_datatable_row_state.dart';
part 'paged_datatable_rows.dart';
part 'paged_datatable_state.dart';
part 'paged_datatable_theme.dart';
part 'pagination_result.dart';
part 'types.dart';

/// A paginated DataTable that allows page caching and filtering
/// [TKey] is the type of the page token
/// [TResult] is the type of data the data table will show.
class PagedDataTable<TKey extends Comparable, TResultId extends Comparable, TResult extends Object>
    extends StatelessWidget {
  /// The callback that gets executed when a page is fetched.
  final FetchCallback<TKey, TResult> fetchPage;

  /// The initial page to fetch.
  final TKey initialPage;

  /// The list of filters to show.
  final List<TableFilter>? filters;

  /// A custom controller used to programatically control the table.
  final PagedDataTableController<TKey, TResultId, TResult>? controller;

  /// The list of columns to display.
  final List<BaseTableColumn<TResult>> columns;

  /// A custom menu tooltip to show in the filter bar.
  final PagedDataTableFilterBarMenu? menu;

  /// A custom widget to build in the footer, aligned to the left.
  ///
  /// Navigation widgets remain untouched.
  final Widget? footer;

  /// A custom widget to build in the footer, aligned to the left.
  ///
  /// Filter widgets remain untouched.
  final Widget? header;

  /// A custom builder that display any error.
  final ErrorBuilder? errorBuilder;

  /// A custom builder that builds when no item is found.
  final WidgetBuilder? noItemsFoundBuilder;

  /// A custom theme to apply only to this DataTable instance.
  final PagedDataTableThemeData? theme;

  /// Indicates if the table allows the user to select rows.
  final bool rowsSelectable;

  /// A custom builder that builds a row.
  final CustomRowBuilder<TResult>? customRowBuilder;

  /// A stream to listen and refresh the table when any update is received.
  final Stream? refreshListener;

  /// A function that returns the id of an item.
  final ModelIdGetter<TResultId, TResult> idGetter;

  const PagedDataTable(
      {required this.fetchPage,
      required this.initialPage,
      required this.columns,
      required this.idGetter,
      this.filters,
      this.menu,
      this.controller,
      this.footer,
      this.header,
      this.theme,
      this.errorBuilder,
      this.noItemsFoundBuilder,
      this.rowsSelectable = false,
      this.customRowBuilder,
      this.refreshListener,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_PagedDataTableState<TKey, TResultId, TResult>>(
      create: (context) => _PagedDataTableState(
          columns: columns,
          rowsSelectable: rowsSelectable,
          filters: filters,
          idGetter: idGetter,
          controller: controller,
          fetchCallback: fetchPage,
          initialPage: initialPage,
          refreshListener: refreshListener),
      builder: (context, widget) {
        var state = context.read<_PagedDataTableState<TKey, TResultId, TResult>>();
        final localTheme =
            PagedDataTableTheme.maybeOf(context) ?? theme ?? _kDefaultPagedDataTableTheme;

        Widget child = Material(
          color: localTheme.backgroundColor,
          elevation: 0,
          textStyle: localTheme.textStyle,
          shape: theme?.border,
          child: LayoutBuilder(builder: (context, constraints) {
            var width = constraints.maxWidth - (columns.length * 32) - (rowsSelectable ? 32 : 0);
            state.availableWidth = width;
            return Column(
              children: [
                /* FILTER TAB */
                if (header != null || menu != null || state.filters.isNotEmpty) ...[
                  _PagedDataTableFilterTab<TKey, TResultId, TResult>(menu, header),
                  Divider(height: 0, color: localTheme.dividerColor),
                ],

                /* HEADER ROW */
                _PagedDataTableHeaderRow<TKey, TResultId, TResult>(rowsSelectable, width),
                Divider(height: 0, color: localTheme.dividerColor),

                /* ITEMS */
                Expanded(
                  child: _PagedDataTableRows<TKey, TResultId, TResult>(
                      rowsSelectable,
                      customRowBuilder ??
                          CustomRowBuilder<TResult>(
                              builder: (context, item) =>
                                  throw UnimplementedError("This does not build nothing"),
                              shouldUse: (context, item) => false),
                      noItemsFoundBuilder,
                      errorBuilder,
                      width),
                ),

                /* FOOTER */
                if (localTheme.configuration.footer.footerVisible) ...[
                  Divider(height: 0, color: localTheme.dividerColor),
                  _PagedDataTableFooter<TKey, TResultId, TResult>(footer)
                ]
              ],
            );
          }),
        );

        // apply configuration to this widget only
        if (theme != null) {
          child = PagedDataTableTheme(data: theme!, child: child);
          assert(theme!.rowColors != null ? theme!.rowColors!.length == 2 : true,
              "rowColors must contain exactly two colors");
        } else {
          assert(localTheme.rowColors != null ? localTheme.rowColors!.length == 2 : true,
              "rowColors must contain exactly two colors");
        }

        return child;
      },
    );
  }
}
