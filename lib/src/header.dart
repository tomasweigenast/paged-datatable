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

    return SizedBox(
      height: theme.headerHeight,
      child: DefaultTextStyle(
        style: theme.headerTextStyle,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (fixedColumnCount > 0) ..._buildFixedColumns(context, theme),
            Expanded(
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: horizontalController,
                slivers: _buildColumns(context, theme).map((e) => SliverToBoxAdapter(child: e)).toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFixedColumns(BuildContext context, PagedDataTableThemeData theme) {
    final list = <Widget>[];
    // print(context.size);

    for (int i = 0; i < fixedColumnCount; i++) {
      final column = columns[i];
      list.add(_buildColumn(theme, column));
    }

    return list;
  }

  List<Widget> _buildColumns(BuildContext context, PagedDataTableThemeData theme) {
    final list = <Widget>[];
    for (int i = fixedColumnCount; i < columns.length; i++) {
      final column = columns[i];
      list.add(_buildColumn(theme, column));
    }

    return list;
  }

  Widget _buildColumn(PagedDataTableThemeData theme, ReadOnlyTableColumn column) {
    Widget child = Container(
      padding: theme.cellPadding,
      margin: theme.padding,
      child: Align(
        alignment: Alignment.centerLeft,
        child: column.title,
      ),
    );

    if (column.size is FractionalColumnSize) {
      debugPrint("Column ${column.title} width will be: ${width * (column.size as FractionalColumnSize).fraction}");
    }

    return switch (column.size) {
      FixedColumnSize(:final size) => SizedBox(width: size, child: child),
      FractionalColumnSize(:final fraction) => SizedBox(width: width * fraction, child: child),
      RemainingColumnSize() => SizedBox(width: width, child: child)
    };
  }
}
