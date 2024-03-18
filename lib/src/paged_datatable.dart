import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/linked_scroll_controller.dart';

import 'table_view/table.dart';
import 'table_view/table_cell.dart';
import 'table_view/table_span.dart';

part 'state.dart';
part 'header.dart';

typedef Fetcher<K extends Comparable<K>, T> = FutureOr<(List<T> resultset, K? nextPageToken)> Function(
    int pageSize, K? pageToken);

final class PagedDataTable<K extends Comparable<K>, T> extends StatefulWidget {
  final TableController<K, T>? controller;
  final List<ReadOnlyTableColumn<T>> columns;
  final int initialPageSize;
  final List<int>? pageSizes;
  final Fetcher<K, T> fetcher;
  final int fixedColumnCount;

  const PagedDataTable({
    required this.columns,
    required this.fetcher,
    this.initialPageSize = 50,
    this.pageSizes = const [10, 50, 100],
    this.controller,
    this.fixedColumnCount = 0,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PagedDataTableState<K, T>();
}

final class _PagedDataTableState<K extends Comparable<K>, T> extends State<PagedDataTable<K, T>> {
  final horizontalController = ScrollController();
  final linkedControllers = LinkedScrollControllerGroup();
  late final verticalTableViewController = linkedControllers.addAndGet();
  late final verticalFixedColumsnController = linkedControllers.addAndGet();
  late final headerHorizontalController = linkedControllers.addAndGet();
  late final TableController<K, T> tableController;
  late FixedTableSpanExtent rowSpanExtent, headerRowSpanExtent;
  late PagedDataTableThemeData theme;

  @override
  void initState() {
    super.initState();
    assert(widget.pageSizes != null ? widget.pageSizes!.contains(widget.initialPageSize) : true,
        "initialPageSize must be inside pageSizes. To disable this restriction, set pageSizes to null.");

    tableController = widget.controller ?? TableController();
    tableController._init(
      columns: widget.columns,
      initialPageSize: widget.initialPageSize,
      fetcher: widget.fetcher,
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
    rowSpanExtent = FixedTableSpanExtent(theme.rowHeight);
    headerRowSpanExtent = FixedTableSpanExtent(theme.headerHeight);

    return Card(
      elevation: theme.elevation,
      shape: RoundedRectangleBorder(borderRadius: theme.borderRadius),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // This LayoutBuilder is to get the same width as the TableView
          LayoutBuilder(
              builder: (context, constraints) => _Header(
                  width: constraints.maxWidth,
                  controller: tableController,
                  columns: widget.columns,
                  fixedColumnCount: widget.fixedColumnCount)),
          DefaultTextStyle(
            style: theme.cellTextStyle,
            child: Expanded(
              child: Scrollbar(
                controller: verticalTableViewController,
                thumbVisibility: true,
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: Scrollbar(
                        controller: horizontalController,
                        thumbVisibility: true,
                        child: TableView.builder(
                          pinnedColumnCount: widget.fixedColumnCount,
                          verticalDetails: ScrollableDetails.vertical(controller: verticalTableViewController),
                          horizontalDetails: ScrollableDetails.horizontal(controller: horizontalController),
                          columnCount: widget.columns.length,
                          rowCount: tableController.totalItems,
                          rowBuilder: _buildRowSpan,
                          columnBuilder: _buildColumnSpan,
                          cellBuilder: _buildCell,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 0),
          SizedBox(
            height: theme.footerHeight,
            child: const Center(child: Text("Footer")),
          )
        ],
      ),
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    final itemIndex = vicinity.row;
    final column = widget.columns[vicinity.column];

    // header
    // if (itemIndex == 0) {
    //   return TableViewCell(
    //     child: Padding(
    //       padding: theme.padding,
    //       child: column.format.transform(
    //         Padding(
    //           padding: theme.cellPadding,
    //           child: Tooltip(
    //             message: column.tooltip ?? (column.title is Text ? ((column.title as Text).data ?? kEmptyString) : kEmptyString),
    //             child: Center(
    //               child: DefaultTextStyle(
    //                 style: theme.headerTextStyle,
    //                 child: column.title,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    final item = tableController._currentDataset[itemIndex];

    return TableViewCell(
      child: switch (column) {
        TableColumn<T>(:final cellBuilder) => Padding(
            padding: theme.padding,
            child: column.format.transform(
              Padding(
                padding: theme.cellPadding,
                child: cellBuilder(context, item, itemIndex),
              ),
            ),
          ),
      },
    );
  }

  TableSpan _buildColumnSpan(int index) {
    final column = widget.columns[index];
    return TableSpan(
        extent: switch (column.size) {
          RemainingColumnSize() => const RemainingTableSpanExtent(),
          FixedColumnSize(:final size) => FixedTableSpanExtent(size),
          FractionalColumnSize(:final fraction) => FractionalTableSpanExtent(fraction)
        },
        padding: const TableSpanPadding.all(0),
        foregroundDecoration: TableSpanDecoration(
            border: TableSpanBorder(
          leading: BorderSide(width: 1),
          trailing: BorderSide(width: 1),
        )));

    /*switch (index % 5) {
      case 0:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(100),
          recognizerFactories: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (TapGestureRecognizer t) => t.onTap = () => print('Tap column $index'),
            ),
          },
        );
      case 1:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FractionalTableSpanExtent(0.2),
          onEnter: (_) => print('Entered column $index'),
        );
      case 2:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(120),
          onEnter: (_) => print('Entered column $index'),
        );
      case 3:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const RemainingTableSpanExtent(),
          onEnter: (_) => print('Entered column $index'),
        );
      case 4:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(260),
          onEnter: (_) => print('Entered column $index'),
        );
    }*/
  }

  TableSpan _buildRowSpan(int index) {
    if (index == 0) {
      return TableSpan(
          extent: headerRowSpanExtent,
          foregroundDecoration: const TableSpanDecoration(
            border: TableSpanBorder(
              trailing: BorderSide(width: 1, color: Color(0xFFD6D6D6)),
            ),
          ));
    }

    final TableSpanDecoration decoration = TableSpanDecoration(
      color: index.isEven ? Colors.purple[100] : null,
      border: const TableSpanBorder(
        trailing: BorderSide(width: 1, color: Color(0xFFD6D6D6)),
      ),
    );

    return TableSpan(
      backgroundDecoration: decoration,
      extent: rowSpanExtent,
    );
  }

  @override
  void dispose() {
    super.dispose();
    tableController.dispose();
    verticalFixedColumsnController.dispose();
    verticalTableViewController.dispose();
    horizontalController.dispose();
    headerHorizontalController.dispose();
  }
}
