import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
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
class PagedDataTable<TKey extends Object, TResult extends Object>
    extends StatelessWidget {
  final FetchCallback<TKey, TResult> fetchPage;
  final TKey initialPage;
  final List<TableFilter>? filters;
  final PagedDataTableController<TKey, TResult>? controller;
  final List<BaseTableColumn<TResult>> columns;
  final PagedDataTableFilterBarMenu? menu;
  final Widget? footer, header;
  final ErrorBuilder? errorBuilder;
  final WidgetBuilder? noItemsFoundBuilder;
  final PagedDataTableThemeData? theme;
  final bool rowsSelectable;
  final CustomRowBuilder<TResult>? customRowBuilder;
  final Stream? refreshListener;

  const PagedDataTable(
      {required this.fetchPage,
      required this.initialPage,
      required this.columns,
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
    return ChangeNotifierProvider<_PagedDataTableState<TKey, TResult>>(
      create: (context) => _PagedDataTableState(
          columns: columns,
          rowsSelectable: rowsSelectable,
          filters: filters,
          controller: controller,
          fetchCallback: fetchPage,
          initialPage: initialPage,
          refreshListener: refreshListener),
      builder: (context, widget) {
        var state = context.read<_PagedDataTableState<TKey, TResult>>();
        final localTheme = PagedDataTableTheme.maybeOf(context) ??
            theme ??
            _kDefaultPagedDataTableTheme;

        Widget child = Material(
          color: localTheme.backgroundColor,
          elevation: 0,
          textStyle: localTheme.textStyle,
          shape: theme?.border,
          child: LayoutBuilder(builder: (context, constraints) {
            var width = constraints.maxWidth - (columns.length * 32);
            state.availableWidth = width;
            return Column(
              children: [
                /* FILTER TAB */
                if (header != null ||
                    menu != null ||
                    state.filters.isNotEmpty) ...[
                  _PagedDataTableFilterTab<TKey, TResult>(menu, header),
                  Divider(height: 0, color: localTheme.dividerColor),
                ],

                /* HEADER ROW */
                _PagedDataTableHeaderRow<TKey, TResult>(rowsSelectable, width),
                Divider(height: 0, color: localTheme.dividerColor),

                /* ITEMS */
                Expanded(
                  child: _PagedDataTableRows<TKey, TResult>(
                      rowsSelectable,
                      customRowBuilder,
                      noItemsFoundBuilder,
                      errorBuilder,
                      width),
                ),

                /* FOOTER */
                Divider(height: 0, color: localTheme.dividerColor),
                _PagedDataTableFooter<TKey, TResult>(footer)
              ],
            );
          }),
        );

        // apply configuration to this widget only
        if (theme != null) {
          child = PagedDataTableTheme(data: theme!, child: child);
          assert(
              theme!.rowColors != null ? theme!.rowColors!.length == 2 : true,
              "rowColors must contain exactly two colors");
        } else {
          assert(
              localTheme.rowColors != null
                  ? localTheme.rowColors!.length == 2
                  : true,
              "rowColors must contain exactly two colors");
        }

        return child;
      },
    );
  }
}
