import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'paged_datatable_column.dart';
part 'paged_datatable_column_header.dart';
part 'paged_datatable_controller.dart';
part 'paged_datatable_rows.dart';
part 'paged_datatable_state.dart';
part 'pagination_result.dart';
part 'types.dart';

/// A paginated DataTable that allows page caching and filtering
/// [TKey] is the type of the page token
/// [TResult] is the type of data the data table will show.
class PagedDataTable<TKey extends Object, TResult extends Object> extends StatelessWidget {

  final FetchCallback<TKey, TResult> fetchPage;
  final TKey initialPage;
  final PagedDataTableController<TKey, TResult>? controller;
  final List<TableColumn<TResult>> columns;

  const PagedDataTable({
    required this.fetchPage,
    required this.initialPage,
    required this.columns,
    this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<_PagedDataTableState<TKey, TResult>>(
      create: (context) => _PagedDataTableState(
        columns: columns,
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
              /* HEADER ROW */
              _PagedDataTableHeaderRow<TKey, TResult>(),
              const Divider(height: 0),
              Expanded(child: _PagedDataTableRows<TKey, TResult>())
            ],
          ),
        ),
      ),
    );
  }
}