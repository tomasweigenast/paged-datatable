part of 'paged_datatable.dart';

final class _Header<K extends Comparable<K>, T> extends StatelessWidget {
  final TableController<K, T> controller;
  final int fixedColumnCount;
  final List<ReadOnlyTableColumn> columns;
  final double width;
  final ScrollController horizontalController;

  const _Header({
    required this.width,
    required this.controller,
    required this.columns,
    required this.fixedColumnCount,
    required this.horizontalController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = PagedDataTableTheme.of(context);
    final (fixedColumns, _) = _buildFixedColumns(context, width, theme);
    final (columns, _) = _buildColumns(context, width, theme);

    return SizedBox(
      height: theme.headerHeight,
      child: DefaultTextStyle(
        style: theme.headerTextStyle,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (fixedColumnCount > 0) ...fixedColumns,
            Expanded(
              child: _ScrollableColumns(
                  controller: horizontalController,
                  children: columns.map((e) => SliverToBoxAdapter(child: e)).toList(growable: false)),
            ),
          ],
        ),
      ),
    );
  }

  (List<Widget>, double) _buildFixedColumns(BuildContext context, double totalWidth, PagedDataTableThemeData theme) {
    final list = <Widget>[];

    double remainingWidth = totalWidth;
    for (int i = 0; i < fixedColumnCount; i++) {
      final column = columns[i];
      final (widget, width) = _buildColumn(theme, remainingWidth, column);
      list.add(widget);
      remainingWidth = width;
    }

    return (list, remainingWidth);
  }

  (List<Widget>, double) _buildColumns(BuildContext context, double totalWidth, PagedDataTableThemeData theme) {
    final list = <Widget>[];
    double remainingWidth = totalWidth;
    for (int i = fixedColumnCount; i < columns.length; i++) {
      final column = columns[i];
      final (widget, width) = _buildColumn(theme, remainingWidth, column);
      list.add(widget);
      remainingWidth = width;
    }

    return (list, remainingWidth);
  }

  (Widget, double) _buildColumn(PagedDataTableThemeData theme, double availableWidth, ReadOnlyTableColumn column) {
    Widget child = Container(
      padding: theme.cellPadding,
      margin: theme.padding,
      child: column.format.transform(column.title),
    );

    if (column.size is FractionalColumnSize) {
      debugPrint("Column ${column.title} width will be: ${width * (column.size as FractionalColumnSize).fraction}");
    }

    switch (column.size) {
      case FixedColumnSize(:final size):
        child = SizedBox(width: size, child: child);
        availableWidth -= size;
        break;
      case FractionalColumnSize(:final fraction):
        final size = width * fraction;
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
}

class _ScrollableColumns extends ScrollView {
  final List<Widget> children;

  const _ScrollableColumns({required this.children, required ScrollController controller})
      : super(scrollDirection: Axis.horizontal, controller: controller);

  @override
  List<Widget> buildSlivers(BuildContext context) => children;
}
