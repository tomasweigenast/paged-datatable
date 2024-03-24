part of 'paged_datatable.dart';

/// A Row renderer that uses two lists for two directional scrolling
class _DoubleListRows<K extends Comparable<K>, T> extends StatefulWidget {
  final List<ReadOnlyTableColumn> columns;
  final ScrollController horizontalController;
  final int fixedColumnCount;
  final TableController<K, T> controller;
  final PagedDataTableConfiguration configuration;

  const _DoubleListRows({
    required this.columns,
    required this.fixedColumnCount,
    required this.horizontalController,
    required this.controller,
    required this.configuration,
  });

  @override
  State<StatefulWidget> createState() => _DoubleListRowsState<K, T>();
}

class _DoubleListRowsState<K extends Comparable<K>, T> extends State<_DoubleListRows<K, T>> {
  final scrollControllerGroup = LinkedScrollControllerGroup();
  late final fixedController = scrollControllerGroup.addAndGet();
  late final normalController = scrollControllerGroup.addAndGet();

  late _TableState state;

  @override
  void initState() {
    super.initState();

    state = widget.controller._state;
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = PagedDataTableTheme.of(context);

    return DefaultTextStyle(
      style: theme.cellTextStyle,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Opacity(
          opacity: widget.controller._state == _TableState.idle ? 1 : 0.5,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // compute available widths
              var availableViewport = constraints.maxWidth;
              var totalWidth = 0.0;
              var fixedWidth = 0.0;
              for (int i = 0; i < widget.columns.length; i++) {
                final col = widget.columns[i];
                final thisWidth = switch (col.size) {
                  FixedColumnSize(:final size) => size,
                  RemainingColumnSize() => availableViewport,
                  FractionalColumnSize(:final fraction) => constraints.maxWidth * fraction
                };
                availableViewport -= thisWidth;
                totalWidth += thisWidth;

                if (i < widget.fixedColumnCount) {
                  fixedWidth += thisWidth;
                }
              }

              return Scrollbar(
                thumbVisibility: theme.verticalScrollbarVisibility,
                controller: normalController,
                child: Row(
                  children: [
                    SizedBox(
                      width: fixedWidth,
                      child: ListView.separated(
                        primary: false,
                        controller: fixedController,
                        itemCount: widget.controller._totalItems,
                        separatorBuilder: (_, __) => const Divider(height: 0, color: Color(0xFFD6D6D6)),
                        itemBuilder: (context, index) {
                          Widget child = Row(children: _buildFixedColumnsRow(context, index, constraints.maxWidth, theme));
                          final color = theme.cellColor?.call(index);
                          if (color != null) {
                            child = DecoratedBox(decoration: BoxDecoration(color: color), child: child);
                          }
                          return SizedBox(height: theme.rowHeight, child: child);
                        },
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: theme.horizontalScrollbarVisibility,
                        controller: widget.horizontalController,
                        child: ListView(
                          controller: widget.horizontalController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: totalWidth, maxHeight: constraints.maxHeight),
                              child: ListView.separated(
                                controller: normalController,
                                itemCount: widget.controller._totalItems,
                                separatorBuilder: (_, __) => const Divider(height: 0, color: Color(0xFFD6D6D6)),
                                itemBuilder: (context, index) {
                                  Widget child =
                                      Row(children: _buildNormalColumnRow(context, index, constraints.maxWidth, theme));

                                  final color = theme.cellColor?.call(index);
                                  if (color != null) {
                                    child = DecoratedBox(decoration: BoxDecoration(color: color), child: child);
                                  }
                                  return SizedBox(height: theme.rowHeight, child: child);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFixedColumnsRow(BuildContext context, int index, double totalWidth, PagedDataTableThemeData theme) {
    final item = widget.controller._currentDataset[index];
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

  List<Widget> _buildNormalColumnRow(BuildContext context, int index, double totalWidth, PagedDataTableThemeData theme) {
    final item = widget.controller._currentDataset[index];
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

  (Widget, double) _buildCell(BuildContext context, int index, T value, PagedDataTableThemeData theme, double totalWidth,
      double availableWidth, ReadOnlyTableColumn column) {
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

  @override
  void dispose() {
    super.dispose();

    normalController.dispose();
    fixedController.dispose();
  }
}
