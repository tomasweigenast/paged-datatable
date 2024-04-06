part of 'paged_datatable.dart';

final class _Header<K extends Comparable<K>, T> extends StatefulWidget {
  final TableController<K, T> controller;
  final int fixedColumnCount;
  final List<ReadOnlyTableColumn> columns;
  final ScrollController horizontalController;
  final PagedDataTableConfiguration configuration;
  final List<double> sizes;

  const _Header({
    required this.sizes,
    required this.controller,
    required this.columns,
    required this.fixedColumnCount,
    required this.horizontalController,
    required this.configuration,
  });

  @override
  State<StatefulWidget> createState() => _HeaderState<K, T>();
}

final class _HeaderState<K extends Comparable<K>, T> extends State<_Header<K, T>> {
  late _TableState tableState;
  SortModel? sortModel;

  @override
  void initState() {
    super.initState();

    sortModel = widget.controller.sortModel;
    tableState = widget.controller._state;
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  Widget build(BuildContext context) {
    final theme = PagedDataTableTheme.of(context);
    final fixedColumns = _buildFixedColumns(context, theme);
    final columns = _buildColumns(context, theme);

    return SizedBox(
      height: theme.headerHeight,
      child: DefaultTextStyle(
        style: theme.headerTextStyle,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Row(
              children: [
                if (widget.fixedColumnCount > 0) ...fixedColumns,
                Expanded(
                  child: _ScrollableColumns(
                      controller: widget.horizontalController,
                      children: columns.map((e) => SliverToBoxAdapter(child: e)).toList(growable: false)),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: tableState == _TableState.fetching ? const LinearProgressIndicator() : const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFixedColumns(BuildContext context, PagedDataTableThemeData theme) {
    final list = <Widget>[];

    for (int i = 0; i < widget.fixedColumnCount; i++) {
      final column = widget.columns[i];
      list.add(_buildColumn(context, theme, widget.sizes[i], column));
    }

    return list;
  }

  List<Widget> _buildColumns(BuildContext context, PagedDataTableThemeData theme) {
    final list = <Widget>[];
    for (int i = widget.fixedColumnCount; i < widget.columns.length; i++) {
      final column = widget.columns[i];
      list.add(_buildColumn(context, theme, widget.sizes[i], column));
    }

    return list;
  }

  Widget _buildColumn(BuildContext context, PagedDataTableThemeData theme, double width, ReadOnlyTableColumn column) {
    Widget child = Container(
      padding: theme.cellPadding,
      margin: theme.padding,
      child: column.format.transform(
        Tooltip(
            textAlign: TextAlign.left,
            message: column.title is Text
                ? (column.title as Text).data!
                : column.title is RichText
                    ? (column.title as RichText).text.toPlainText()
                    : column.tooltip ?? "",
            child: column.title),
      ),
    );

    if (column.sortable) {
      child = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            widget.controller.swipeSortModel(column.id);
          },
          child: child,
        ),
      );

      if (sortModel?.fieldName == column.id) {
        child = Row(
          children: [
            Flexible(child: child),
            IconButton(
              icon: sortModel!.descending ? const Icon(Icons.arrow_downward) : const Icon(Icons.arrow_upward),
              onPressed: () {
                widget.controller.swipeSortModel(column.id);
              },
            )
          ],
        );
      }
    }

    child = SizedBox(width: width, child: child);

    return child;
  }

  void _onControllerChanged() {
    if (widget.controller.sortModel != sortModel || widget.controller._state != tableState) {
      setState(() {
        sortModel = widget.controller.sortModel;
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

class _ScrollableColumns extends ScrollView {
  final List<Widget> children;

  const _ScrollableColumns({required this.children, required ScrollController controller})
      : super(scrollDirection: Axis.horizontal, controller: controller);

  @override
  List<Widget> buildSlivers(BuildContext context) => children;
}
