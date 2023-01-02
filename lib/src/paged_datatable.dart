import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';

part 'paged_datatable_column.dart';
part 'paged_datatable_column_header.dart';
part 'paged_datatable_controller.dart';
part 'paged_datatable_filter.dart';
part 'paged_datatable_filter_bar.dart';
part 'paged_datatable_filter_bar_menu.dart';
part 'paged_datatable_menu.dart';
part 'paged_datatable_footer.dart';
part 'paged_datatable_rows.dart';
part 'paged_datatable_state.dart';
part 'paged_datatable_configuration.dart';
part 'pagination_result.dart';
part 'types.dart';
part 'controls.dart';

/// A paginated DataTable that allows page caching and filtering
/// [TKey] is the type of the page token
/// [TResult] is the type of data the data table will show.
class PagedDataTable<TKey extends Object, TResult extends Object> extends StatelessWidget {

  final FetchCallback<TKey, TResult> fetchPage;
  final TKey initialPage;
  final List<TableFilter>? filters;
  final PagedDataTableController<TKey, TResult>? controller;
  final List<BaseTableColumn<TResult>> columns;
  final PagedDataTableFilterBarMenu? menu;
  final Widget? footer, header;
  final ErrorBuilder? errorBuilder;
  final WidgetBuilder? noItemsFoundBuilder;
  final PagedDataTableConfigurationData? configuration;

  const PagedDataTable({
    required this.fetchPage,
    required this.initialPage,
    required this.columns,
    this.filters,
    this.menu,
    this.controller,
    this.footer,
    this.header,
    this.configuration,
    this.errorBuilder,
    this.noItemsFoundBuilder,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if(configuration != null) {
      // TODO: config
    }

    return ChangeNotifierProvider<_PagedDataTableState<TKey, TResult>>(
      create: (context) => _PagedDataTableState(
        columns: columns,
        filters: filters,
        controller: controller,
        fetchCallback: fetchPage,
        initialPage: initialPage,
        viewSize: size
      ),
      builder: (context, widget) => Consumer<_PagedDataTableState<TKey, TResult>>(
        builder: (context, model, child) {
          Widget child = Material(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              side: BorderSide(
                color: Color(0xffDADCE0)
              )
            ),
            child: Column(
              children: [
                /* FILTER TAB */
                _PagedDataTableFilterTab<TKey, TResult>(menu, header),
                const Divider(height: 0),

                /* HEADER ROW */
              _PagedDataTableHeaderRow<TKey, TResult>(),
                const Divider(height: 0),
                  
                /* ITEMS */
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: model.tableState == _TableState.loading ? .3 : 1,
                    child: _PagedDataTableRows<TKey, TResult>(noItemsFoundBuilder, errorBuilder),
                  ),
                ),
      
                /* FOOTER */
                const Divider(height: 0),
                _PagedDataTableFooter<TKey, TResult>(footer)
              ],
            ),
          );

          if(configuration != null) {
            child = PagedDataTableConfiguration(data: configuration!, child: child);
          }

          return child;
        },
      ),
    );
  }
}