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
                        itemBuilder: (context, index) => _FixedPartRow<K, T>(
                            index: index,
                            totalWidth: constraints.maxWidth,
                            fixedColumnCount: widget.fixedColumnCount,
                            columns: widget.columns),
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
                                itemBuilder: (context, index) => _VariablePartRow<K, T>(
                                  index: index,
                                  totalWidth: constraints.maxWidth,
                                  fixedColumnCount: widget.fixedColumnCount,
                                  columns: widget.columns,
                                ),
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

  @override
  void dispose() {
    super.dispose();

    normalController.dispose();
    fixedController.dispose();
  }
}
