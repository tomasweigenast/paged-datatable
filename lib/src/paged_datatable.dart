import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:paged_datatable/src/linked_scroll_controller.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

final class PagedDataTable extends StatefulWidget {
  const PagedDataTable({super.key});

  @override
  State<StatefulWidget> createState() => _PagedDataTableState();
}

final class _PagedDataTableState extends State<PagedDataTable> {
  final _horizontalController = ScrollController();
  final _linkedControllers = LinkedScrollControllerGroup();
  late final _verticalTableViewController = _linkedControllers.addAndGet();
  late final _verticalFixedColumsnController = _linkedControllers.addAndGet();
  final _rowCount = 100;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 52,
            color: Colors.blue,
            child: const Center(child: Text("Header")),
          ),
          const Divider(height: 0),
          Expanded(
            child: Scrollbar(
              controller: _verticalTableViewController,
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ListView.builder(
                        controller: _verticalFixedColumsnController,
                        itemCount: 100,
                        itemBuilder: (context, index) => SizedBox(
                          height: 62,
                          child: Center(child: Text("Fixed $index")),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: TableView.builder(
                        verticalDetails: ScrollableDetails.vertical(controller: _verticalTableViewController),
                        horizontalDetails: ScrollableDetails.horizontal(controller: _horizontalController),
                        columnCount: 20,
                        rowCount: _rowCount,
                        rowBuilder: _buildRowSpan,
                        columnBuilder: _buildColumnSpan,
                        cellBuilder: _buildCell,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 0),
          Container(
            height: 62,
            color: Colors.red,
            child: const Center(child: Text("Footer")),
          )
        ],
      ),
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    return TableViewCell(
      child: Center(
        child: Text('Tile c: ${vicinity.column}, r: ${vicinity.row}'),
      ),
    );
  }

  TableSpan _buildColumnSpan(int index) {
    const TableSpanDecoration decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(),
      ),
    );

    switch (index % 5) {
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
          extent: const FractionalTableSpanExtent(0.5),
          onEnter: (_) => print('Entered column $index'),
          cursor: SystemMouseCursors.contextMenu,
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
          extent: const FixedTableSpanExtent(145),
          onEnter: (_) => print('Entered column $index'),
        );
      case 4:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(200),
          onEnter: (_) => print('Entered column $index'),
        );
    }
    throw AssertionError('This should be unreachable, as every index is accounted for in the switch clauses.');
  }

  TableSpan _buildRowSpan(int index) {
    final TableSpanDecoration decoration = TableSpanDecoration(
      color: index.isEven ? Colors.purple[100] : null,
      border: const TableSpanBorder(
        trailing: BorderSide(
          width: 3,
        ),
      ),
    );

    return TableSpan(
      backgroundDecoration: decoration,
      extent: const FixedTableSpanExtent(62),
      cursor: SystemMouseCursors.click,
    );
  }
}
