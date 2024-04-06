part of 'paged_datatable.dart';

/// A Row renderer that uses two lists for two directional scrolling
class _DoubleListRows<K extends Comparable<K>, T> extends StatefulWidget {
  final List<ReadOnlyTableColumn> columns;
  final ScrollController horizontalController;
  final int fixedColumnCount;
  final TableController<K, T> controller;
  final PagedDataTableConfiguration configuration;
  final List<double> sizes;

  const _DoubleListRows({
    required this.columns,
    required this.fixedColumnCount,
    required this.horizontalController,
    required this.controller,
    required this.configuration,
    required this.sizes,
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
          child: Scrollbar(
            thumbVisibility: theme.verticalScrollbarVisibility,
            controller: normalController,
            child: Row(
              children: [
                SizedBox(
                  width: widget.sizes.take(widget.fixedColumnCount).fold(0.0, (a, b) => a! + b),
                  child: ListView.separated(
                    primary: false,
                    controller: fixedController,
                    itemCount: widget.controller._totalItems,
                    separatorBuilder: (_, __) => const Divider(height: 0, color: Color(0xFFD6D6D6)),
                    itemBuilder: (context, index) => _FixedPartRow<K, T>(
                      index: index,
                      fixedColumnCount: widget.fixedColumnCount,
                      sizes: widget.sizes,
                      columns: widget.columns,
                    ),
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
                          constraints:
                              BoxConstraints(maxWidth: widget.sizes.skip(widget.fixedColumnCount).fold(0.0, (a, b) => a + b)),
                          child: ListView.separated(
                            controller: normalController,
                            itemCount: widget.controller._totalItems,
                            separatorBuilder: (_, __) => const Divider(height: 0, color: Color(0xFFD6D6D6)),
                            itemBuilder: (context, index) => _VariablePartRow<K, T>(
                              sizes: widget.sizes,
                              index: index,
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
