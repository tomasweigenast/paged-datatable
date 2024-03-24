part of 'paged_datatable.dart';

/// A row renderer that uses TableView
class _TableViewRows<K extends Comparable<K>, T> extends StatefulWidget {
  final TableController controller;
  final ScrollController horizontalController, verticalController;
  final int fixedColumnCount;
  final List<ReadOnlyTableColumn> columns;

  const _TableViewRows(
      {required this.controller,
      required this.horizontalController,
      required this.verticalController,
      required this.columns,
      required this.fixedColumnCount});

  @override
  State<_TableViewRows<K, T>> createState() => _TableViewRowsState<K, T>();
}

class _TableViewRowsState<K extends Comparable<K>, T> extends State<_TableViewRows<K, T>> {
  late PagedDataTableThemeData theme;
  late FixedTableSpanExtent rowSpanExtent;

  late _TableState tableState;

  @override
  void initState() {
    super.initState();

    tableState = widget.controller._state;
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  Widget build(BuildContext context) {
    theme = PagedDataTableTheme.of(context);
    rowSpanExtent = FixedTableSpanExtent(theme.rowHeight);

    return Opacity(
      opacity: tableState == _TableState.idle ? 1 : 0.3,
      child: DefaultTextStyle(
        style: theme.cellTextStyle,
        child: Scrollbar(
          controller: widget.verticalController,
          thumbVisibility: true,
          child: Scrollbar(
            controller: widget.horizontalController,
            thumbVisibility: true,
            child: TableView.builder(
              pinnedColumnCount: widget.fixedColumnCount,
              verticalDetails: ScrollableDetails.vertical(controller: widget.verticalController),
              horizontalDetails: ScrollableDetails.horizontal(controller: widget.horizontalController),
              columnCount: widget.columns.length,
              rowCount: widget.controller.totalItems,
              rowBuilder: _buildRowSpan,
              columnBuilder: _buildColumnSpan,
              cellBuilder: _buildCell,
            ),
          ),
        ),
      ),
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    final itemIndex = vicinity.row;
    final column = widget.columns[vicinity.column];
    final item = widget.controller._currentDataset[itemIndex];

    return TableViewCell(
      child: switch (column) {
        TableColumn<K, T>(:final cellBuilder) => Padding(
            padding: theme.padding,
            child: column.format.transform(
              Padding(
                padding: theme.cellPadding,
                child: cellBuilder(context, item, itemIndex),
              ),
            ),
          ),
        _ => throw UnimplementedError()
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
    );
  }

  TableSpan _buildRowSpan(int index) {
    final TableSpanDecoration decoration = TableSpanDecoration(
      color: theme.cellColor?.call(index),
      border: const TableSpanBorder(
        trailing: BorderSide(width: 1, color: Color(0xFFD6D6D6)),
      ),
    );

    return TableSpan(
      backgroundDecoration: decoration,
      cursor: SystemMouseCursors.click,
      extent: rowSpanExtent,
      recognizerFactories: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (TapGestureRecognizer t) => t.onTap = () => debugPrint('Tap row $index'),
        ),
      },
    );
  }

  void _onControllerChanged() {
    if (tableState != widget.controller._state) {
      setState(() {
        tableState = widget.controller._state;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_onControllerChanged);
  }
}
