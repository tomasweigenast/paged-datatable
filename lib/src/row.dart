part of 'paged_datatable.dart';

abstract class _RowBuilder<K extends Comparable<K>, T> extends StatefulWidget {
  final int index;
  final double totalWidth;

  const _RowBuilder({required this.index, required this.totalWidth, super.key});

  @override
  State<StatefulWidget> createState() => _RowBuilderState<K, T>();

  List<Widget> buildColumns(
      BuildContext context, int index, double totalWidth, TableController<K, T> controller, PagedDataTableThemeData theme);
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
    print("Total width: ${widget.totalWidth}");
    Widget child = Row(children: widget.buildColumns(context, widget.index, widget.totalWidth, controller, theme));
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

  const _FixedPartRow({
    required super.index,
    required super.totalWidth,
    required this.fixedColumnCount,
    required this.columns,
    super.key,
  });

  @override
  List<Widget> buildColumns(
      BuildContext context, int index, double totalWidth, TableController<K, T> controller, PagedDataTableThemeData theme) {
    final item = controller._currentDataset[index];
    final list = <Widget>[];

    double remainingWidth = totalWidth;
    for (int i = 0; i < fixedColumnCount; i++) {
      final column = columns[i];
      final (build, width) = _buildCell(context, index, item, theme, totalWidth, remainingWidth, column);
      list.add(build);
      remainingWidth = width;
    }

    return list;
  }
}

class _VariablePartRow<K extends Comparable<K>, T> extends _RowBuilder<K, T> {
  final List<ReadOnlyTableColumn> columns;
  final int fixedColumnCount;

  const _VariablePartRow({
    required super.index,
    required super.totalWidth,
    required this.fixedColumnCount,
    required this.columns,
    super.key,
  });

  @override
  List<Widget> buildColumns(
      BuildContext context, int index, double totalWidth, TableController<K, T> controller, PagedDataTableThemeData theme) {
    final item = controller._currentDataset[index];
    final list = <Widget>[];
    double remainingWidth = totalWidth;

    for (int i = fixedColumnCount; i < columns.length; i++) {
      final column = columns[i];
      final (built, width) = _buildCell(context, index, item, theme, totalWidth, remainingWidth, column);
      list.add(built);
      remainingWidth = width;
    }

    return list;
  }
}

(Widget widget, double remainingWidth) _buildCell<T>(BuildContext context, int index, T value, PagedDataTableThemeData theme,
    double totalWidth, double availableWidth, ReadOnlyTableColumn column) {
  Widget child = Container(
    padding: theme.cellPadding,
    margin: theme.padding,
    color: Colors.blue,
    child: column.format.transform(column.build(context, value, index)),
  );

  final size = column.size.calculateConstraints(availableWidth);
  availableWidth -= size;
  child = SizedBox(width: size, child: child);
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

  return (child, availableWidth);
}
