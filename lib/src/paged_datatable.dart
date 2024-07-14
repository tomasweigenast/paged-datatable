import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/linked_scroll_controller.dart';
import 'package:paged_datatable/src/table_controller_notifier.dart';

part 'column.dart';
part 'column_widgets.dart';
part 'controller.dart';
part 'double_list_rows.dart';
part 'filter.dart';
part 'filter_bar.dart';
part 'filter_model.dart';
part 'filter_state.dart';
part 'filter_widgets.dart';
part 'footer_widgets.dart';
part 'header.dart';
part 'row.dart';
part 'sort_model.dart';
part 'table_view_rows.dart';

/// [PagedDataTable] renders a table of items that is paginable.
///
/// The type of element to be displayed in the table is [T] and [K] is the type of key
/// used to paginate the table.
final class PagedDataTable<K extends Comparable<K>, T> extends StatefulWidget {
  /// An specific [PagedDataTableController] to be use in this [PagedDataTable].
  final PagedDataTableController<K, T>? controller;

  /// The list of columns to draw in the table.
  final List<ReadOnlyTableColumn<K, T>> columns;

  /// The initial page size of the table.
  ///
  /// If [pageSizes] is not null, this value must match any of the its values.
  final int initialPageSize;

  /// The initial page query.
  final K? initialPage;

  /// The list of page sizes availables to be selected in the footer.
  final List<int>? pageSizes;

  /// The callback used to fetch new items.
  final Fetcher<K, T> fetcher;

  /// The amount of columns to fix, starting from the left.
  final int fixedColumnCount;

  /// The configuration of this [PagedDataTable].
  final PagedDataTableConfiguration configuration;

  /// The widget to display at the footer of the table.
  ///
  /// If null, the default footer will be displayed.
  final Widget? footer;

  /// Additional widget to add at the right of the filter bar.
  final Widget? filterBarChild;

  /// The list of filters to use.
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
    this.filterBarChild,
    this.filters = const <TableFilter>[],
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PagedDataTableState<K, T>();
}

final class _PagedDataTableState<K extends Comparable<K>, T>
    extends State<PagedDataTable<K, T>> {
  final verticalController = ScrollController();
  final linkedControllers = LinkedScrollControllerGroup();
  late final headerHorizontalController = linkedControllers.addAndGet();
  late final horizontalController = linkedControllers.addAndGet();
  late final PagedDataTableController<K, T> tableController;
  // late FixedTableSpanExtent rowSpanExtent, headerRowSpanExtent;
  late PagedDataTableThemeData theme;
  bool selfConstructedController = false;

  @override
  void initState() {
    super.initState();
    assert(
        widget.pageSizes != null
            ? widget.pageSizes!.contains(widget.initialPageSize)
            : true,
        "initialPageSize must be inside pageSizes. To disable this restriction, set pageSizes to null.");

    if (widget.controller == null) {
      selfConstructedController = true;
      tableController = PagedDataTableController();
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

    if (oldWidget.columns.length !=
        widget.columns
            .length /*!listEquals(oldWidget.columns, widget.columns)*/) {
      tableController._reset(columns: widget.columns);
      debugPrint("PagedDataTable<$T> changed and rebuilt.");
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = PagedDataTableTheme.of(context);

    return Card(
      color: theme.backgroundColor,
      elevation: theme.elevation,
      shape: RoundedRectangleBorder(borderRadius: theme.borderRadius),
      margin: EdgeInsets.zero,
      child: TableControllerProvider(
        controller: tableController,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sizes = _calculateColumnWidth(constraints.maxWidth);

            return Column(
              children: [
                _FilterBar<K, T>(child: widget.filterBarChild),

                _Header(
                  controller: tableController,
                  configuration: widget.configuration,
                  columns: widget.columns,
                  sizes: sizes,
                  fixedColumnCount: widget.fixedColumnCount,
                  horizontalController: headerHorizontalController,
                ),
                const Divider(height: 0, color: Color(0xFFD6D6D6)),

                Expanded(
                  child: _DoubleListRows(
                    fixedColumnCount: widget.fixedColumnCount,
                    columns: widget.columns,
                    horizontalController: horizontalController,
                    controller: tableController,
                    configuration: widget.configuration,
                    sizes: sizes,
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
            );
          },
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

  List<double> _calculateColumnWidth(double maxWidth) {
    final sizes =
        List<double>.filled(widget.columns.length, 0.0, growable: false);

    double totalFixedWidth = 0.0;
    double totalFraction = 0.0;
    int remainingColumnCount = 0;
    double totalFractionalWidth = 0.0;

    // First pass to determine widths and types of columns
    for (int i = 0; i < widget.columns.length; i++) {
      final column = widget.columns[i];
      if (column.size.isFixed) {
        final columnSize = column.size.calculateConstraints(maxWidth);
        totalFixedWidth += columnSize;
      } else {
        totalFraction += column.size.fraction;

        // Handle this special case
        if (column.size is RemainingColumnSize) {
          remainingColumnCount++;
        }
      }
    }

    // Ensure totalFraction is within a valid range to prevent overflow
    assert(totalFraction <= 1.0,
        "Total fraction exceeds 1.0, which means the columns will overflow.");

    double remainingWidth = maxWidth -
        totalFixedWidth; // Calculate remaining width after fixed sizes are allocated
    totalFractionalWidth =
        remainingWidth * totalFraction; // Re-calculate total fractional width
    remainingWidth -=
        totalFractionalWidth; // Adjust remaining width to exclude fractional columns' widths for RemainingColumnSize
    final remainingColumnWidth = remainingColumnCount > 0.0
        ? remainingWidth / remainingColumnCount
        : 0.0;

    // Now calculate and assign column sizes
    for (int i = 0; i < widget.columns.length; i++) {
      final column = widget.columns[i];
      if (column.size.isFixed) {
        // Pass totalFixedWidth but the ColumnSize should don't care about it because its a fixed size.
        sizes[i] = column.size.calculateConstraints(totalFixedWidth);
      } else if (column.size is RemainingColumnSize) {
        sizes[i] = remainingColumnWidth;
      } else {
        sizes[i] = totalFractionalWidth * column.size.fraction / totalFraction;
      }
    }

    return sizes;
  }
}
