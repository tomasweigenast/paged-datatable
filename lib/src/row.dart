part of 'paged_datatable.dart';

abstract class _RowBuilder<K extends Comparable<K>, T> extends StatefulWidget {
  final int index;

  const _RowBuilder({required this.index, super.key});

  @override
  State<StatefulWidget> createState() => _RowBuilderState<K, T>();

  List<Widget> buildColumns(BuildContext context, int index, TableController<K, T> controller, PagedDataTableThemeData theme);
}

class _RowBuilderState<K extends Comparable<K>, T> extends State<_RowBuilder<K, T>> {
  late final controller = TableControllerProvider.of<K, T>(context);
  late final theme = PagedDataTableTheme.of(context);
  bool selected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    controller.addRowChangeListener(widget.index, _onRowChanged);
    setState(() {
      selected = controller._selectedRows.contains(widget.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Row(children: widget.buildColumns(context, widget.index, controller, theme));
    var color = theme.cellColor?.call(widget.index);
    if (selected && theme.selectedCellColor != null) {
      color = theme.selectedCellColor;
    }
    if (color != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(color: color),
        child: child,
      );
    }

    return SizedBox(height: theme.rowHeight, child: child);
  }

  void _onRowChanged(int index, T value) {
    if (mounted) {
      setState(() {
        selected = controller._selectedRows.contains(index);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    controller.removeRowChangeListener(widget.index, _onRowChanged);
  }
}

class _FixedPartRow<K extends Comparable<K>, T> extends _RowBuilder<K, T> {
  final int fixedColumnCount;
  final List<ReadOnlyTableColumn> columns;
  final List<double> sizes;

  const _FixedPartRow({
    required super.index,
    required this.fixedColumnCount,
    required this.columns,
    required this.sizes,
    super.key,
  });

  @override
  List<Widget> buildColumns(BuildContext context, int index, TableController<K, T> controller, PagedDataTableThemeData theme) {
    final item = controller._currentDataset[index];
    final list = <Widget>[];

    for (int i = 0; i < fixedColumnCount; i++) {
      final column = columns[i];
      final widget = _buildCell(context, index, item, sizes[i], theme, column);
      list.add(widget);
    }

    return list;
  }
}

class _VariablePartRow<K extends Comparable<K>, T> extends _RowBuilder<K, T> {
  final List<ReadOnlyTableColumn> columns;
  final int fixedColumnCount;
  final List<double> sizes;

  const _VariablePartRow({
    required super.index,
    required this.fixedColumnCount,
    required this.columns,
    required this.sizes,
    super.key,
  });

  @override
  List<Widget> buildColumns(BuildContext context, int index, TableController<K, T> controller, PagedDataTableThemeData theme) {
    final item = controller._currentDataset[index];
    final list = <Widget>[];

    for (int i = fixedColumnCount; i < columns.length; i++) {
      final column = columns[i];
      final widget = _buildCell(context, index, item, sizes[i], theme, column);
      list.add(widget);
    }

    return list;
  }
}

Widget _buildCell<T>(
    BuildContext context, int index, T value, double width, PagedDataTableThemeData theme, ReadOnlyTableColumn column) {
  Widget child = Container(
    padding: theme.cellPadding,
    margin: theme.padding,
    color: Colors.blue,
    child: column.format.transform(column.build(context, value, index)),
  );

  child = SizedBox(width: width, child: child);
  // switch (column.size) {
  //   case FixedColumnSize(:final size):
  //     child = SizedBox(width: size, child: child);
  //     availableWidth -= size;
  //     break;
  //   case FractionalColumnSize(:final fraction):
  //     final size = totalWidth * fraction;
  //     child = SizedBox(width: size, child: child);
  //     availableWidth -= size;
  //     break;
  //   case RemainingColumnSize():
  //     child = SizedBox(width: availableWidth, child: child);
  //     availableWidth = 0;
  //     break;
  // }

  return child;
}
