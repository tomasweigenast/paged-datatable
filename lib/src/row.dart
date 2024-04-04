part of 'paged_datatable.dart';

class _FixedPartRow<K extends Comparable<K>, T> extends StatefulWidget {
  final int index;
  final double maxWidth;
  final int fixedColumnCount;
  final List<ReadOnlyTableColumn> columns;

  const _FixedPartRow({
    required this.index,
    required this.maxWidth,
    required this.fixedColumnCount,
    required this.columns,
    super.key,
  });

  @override
  State<_FixedPartRow<K, T>> createState() => _FixedPartRowState<K, T>();
}

class _FixedPartRowState<K extends Comparable<K>, T> extends State<_FixedPartRow<K, T>> {
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
    final columns = _buildColumns(context, controller, widget.index, widget.maxWidth, theme);

    Widget child = Row(children: columns);
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

  List<Widget> _buildColumns(
      BuildContext context, TableController<K, T> controller, int index, double totalWidth, PagedDataTableThemeData theme) {
    final item = controller._currentDataset[index];
    final list = <Widget>[];

    double remainingWidth = totalWidth;
    for (int i = 0; i < widget.fixedColumnCount; i++) {
      final column = widget.columns[i];
      final (build, width) = _buildCell(context, index, item, theme, totalWidth, remainingWidth, column);
      list.add(build);
      remainingWidth = width;
    }

    return list;
  }

  @override
  void dispose() {
    super.dispose();

    controller.removeRowChangeListener(widget.index, _onRowChanged);
  }
}

class _VariablePartRow<K extends Comparable<K>, T> extends StatefulWidget {
  final int index;
  final double maxWidth;
  final List<ReadOnlyTableColumn> columns;
  final int fixedColumnCount;

  const _VariablePartRow({
    required this.index,
    required this.maxWidth,
    required this.fixedColumnCount,
    required this.columns,
    super.key,
  });

  @override
  State<_VariablePartRow<K, T>> createState() => _VariablePartRowState<K, T>();
}

class _VariablePartRowState<K extends Comparable<K>, T> extends State<_VariablePartRow<K, T>> {
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
    Widget child = Row(children: _buildColumns(context, widget.index, widget.maxWidth, theme));

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

  List<Widget> _buildColumns(BuildContext context, int index, double totalWidth, PagedDataTableThemeData theme) {
    final item = controller._currentDataset[index];
    final list = <Widget>[];
    double remainingWidth = totalWidth;

    for (int i = widget.fixedColumnCount; i < widget.columns.length; i++) {
      final column = widget.columns[i];
      final (built, width) = _buildCell(context, index, item, theme, totalWidth, remainingWidth, column);
      list.add(built);
      remainingWidth = width;
    }

    return list;
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

(Widget widget, double remainingWidth) _buildCell<T>(BuildContext context, int index, T value, PagedDataTableThemeData theme,
    double totalWidth, double availableWidth, ReadOnlyTableColumn column) {
  Widget child = Container(
    padding: theme.cellPadding,
    margin: theme.padding,
    child: column.format.transform(column.build(context, value, index)),
  );

  switch (column.size) {
    case FixedColumnSize(:final size):
      child = SizedBox(width: size, child: child);
      availableWidth -= size;
      break;
    case FractionalColumnSize(:final fraction):
      final size = totalWidth * fraction;
      child = SizedBox(width: size, child: child);
      availableWidth -= size;
      break;
    case RemainingColumnSize():
      child = SizedBox(width: availableWidth, child: child);
      availableWidth = 0;
      break;
  }

  return (child, availableWidth);
}
