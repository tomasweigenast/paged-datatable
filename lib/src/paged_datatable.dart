import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/footer.dart';
import 'package:paged_datatable/src/linked_scroll_controller.dart';
import 'package:paged_datatable/src/table_controller_notifier.dart';

part 'column_widgets.dart';
// import 'table_view/table.dart';
// import 'table_view/table_cell.dart';
// import 'table_view/table_span.dart';

part 'controller.dart';
part 'double_list_rows.dart';
part 'footer_widgets.dart';
part 'header.dart';
part 'row.dart';
part 'table_view_rows.dart';
part 'filter_model.dart';
part 'sort_model.dart';
part 'filter_state.dart';
part 'filter_bar.dart';
part 'filter.dart';

final class PagedDataTable<K extends Comparable<K>, T> extends StatefulWidget {
  final TableController<K, T>? controller;
  final List<ReadOnlyTableColumn<K, T>> columns;
  final int initialPageSize;
  final K? initialPage;
  final List<int>? pageSizes;
  final Fetcher<K, T> fetcher;
  final int fixedColumnCount;
  final PagedDataTableConfiguration configuration;
  final Widget? footer;
  final List<TableFilter> filters;

  const PagedDataTable({
    required this.columns,
    required this.fetcher,
    this.initialPage,
    this.initialPageSize = 50,
    this.pageSizes = const [10, 50, 100],
    this.controller,
    this.fixedColumnCount = 0,
    this.configuration = const PagedDataTableConfiguration(),
    this.footer,
    this.filters = const <TableFilter>[],
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PagedDataTableState<K, T>();
}

final class _PagedDataTableState<K extends Comparable<K>, T> extends State<PagedDataTable<K, T>> {
  final verticalController = ScrollController();
  final linkedControllers = LinkedScrollControllerGroup();
  late final headerHorizontalController = linkedControllers.addAndGet();
  late final horizontalController = linkedControllers.addAndGet();
  late final TableController<K, T> tableController;
  // late FixedTableSpanExtent rowSpanExtent, headerRowSpanExtent;
  late PagedDataTableThemeData theme;
  bool selfConstructedController = false;

  @override
  void initState() {
    super.initState();
    assert(widget.pageSizes != null ? widget.pageSizes!.contains(widget.initialPageSize) : true,
        "initialPageSize must be inside pageSizes. To disable this restriction, set pageSizes to null.");

    if (widget.controller == null) {
      selfConstructedController = true;
      tableController = TableController();
    } else {
      tableController = widget.controller!;
    }
    tableController._init(
      columns: widget.columns,
      pageSizes: widget.pageSizes,
      initialPageSize: widget.initialPageSize,
      fetcher: widget.fetcher,
      config: widget.configuration,
      filters: widget.filters,
    );
  }

  @override
  void didUpdateWidget(covariant PagedDataTable<K, T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.columns.length != widget.columns.length /*!listEquals(oldWidget.columns, widget.columns)*/) {
      tableController._reset(columns: widget.columns);
      debugPrint("PagedDataTable<$T> changed and rebuilt.");
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = PagedDataTableTheme.of(context);

    return Card(
      elevation: theme.elevation,
      shape: RoundedRectangleBorder(borderRadius: theme.borderRadius),
      margin: EdgeInsets.zero,
      child: TableControllerProvider(
        controller: tableController,
        child: Column(
          children: [
            _FilterBar<K, T>(),

            // This LayoutBuilder is to get the same width as the TableView
            LayoutBuilder(
                builder: (context, constraints) => _Header(
                    width: constraints.maxWidth,
                    controller: tableController,
                    configuration: widget.configuration,
                    columns: widget.columns,
                    fixedColumnCount: widget.fixedColumnCount,
                    horizontalController: headerHorizontalController)),
            const Divider(height: 0, color: Color(0xFFD6D6D6)),
            Expanded(
              child: _DoubleListRows(
                fixedColumnCount: widget.fixedColumnCount,
                columns: widget.columns,
                horizontalController: horizontalController,
                controller: tableController,
                configuration: widget.configuration,
              ),
            ),
            // Expanded(
            //   child: _TableViewRows<T>(
            //     columns: widget.columns,
            //     controller: tableController,
            //     fixedColumnCount: widget.fixedColumnCount,
            //     horizontalController: horizontalController,
            //     verticalController: verticalController,
            //   ),
            // ),
            const Divider(height: 0, color: Color(0xFFD6D6D6)),
            SizedBox(
              height: theme.footerHeight,
              child: widget.footer ?? DefaultFooter<K, T>(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    verticalController.dispose();
    horizontalController.dispose();
    headerHorizontalController.dispose();

    if (selfConstructedController) {
      tableController.dispose();
    }
  }
}
