import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

part 'paged_datatable_column.dart';
part 'paged_datatable_column_header.dart';
part 'paged_datatable_controller.dart';
part 'paged_datatable_filter.dart';
part 'paged_datatable_filter_bar.dart';
part 'paged_datatable_footer.dart';
part 'paged_datatable_rows.dart';
part 'paged_datatable_state.dart';
part 'pagination_result.dart';
part 'types.dart';
part 'pickers.dart';

/// A paginated DataTable that allows page caching and filtering
/// [TKey] is the type of the page token
/// [TResult] is the type of data the data table will show.
class PagedDataTable<TKey extends Object, TResult extends Object> extends StatelessWidget {

  final FetchCallback<TKey, TResult> fetchPage;
  final TKey initialPage;
  final List<TableFilter>? filters;
  final PagedDataTableController<TKey, TResult>? controller;
  final List<TableColumn<TResult>> columns;

  const PagedDataTable({
    required this.fetchPage,
    required this.initialPage,
    required this.columns,
    this.filters,
    this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
        builder: (context, model, child) => Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            side: BorderSide(
              color: Color(0xffDADCE0)
            )
          ),
          elevation: 0,
          child: Column(
            children: [
              /* FILTER TAB */
              _PagedDataTableFilterTab<TKey, TResult>(),
              const Divider(height: 0),

              /* HEADER ROW */
             _PagedDataTableHeaderRow<TKey, TResult>(),
              const Divider(height: 0),
                
              /* ITEMS */
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: model.state == _TableState.loading ? .3 : 1,
                  child: _PagedDataTableRows<TKey, TResult>(),
                ),
              ),
    
              /* FOOTER */
              const Divider(height: 0),
              _PagedDataTableFooter<TKey, TResult>()
            ],
          ),
        ),
      ),
    );
  }
}