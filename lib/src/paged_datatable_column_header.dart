part of 'paged_datatable.dart';

class _PagedDataTableHeaderRow<TKey extends Object, TResult extends Object>
    extends StatelessWidget {
  final bool rowsSelectable;
  final double width;

  const _PagedDataTableHeaderRow(this.rowsSelectable, this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /* COLUMNS */
          Selector<_PagedDataTableState<TKey, TResult>, int>(
              selector: (context, state) => state._sortChange,
              builder: (context, isSorted, child) {
                var state = context.read<_PagedDataTableState<TKey, TResult>>();
                return Row(
                  children: state.columns
                      .map((column) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                                width: column.sizeFactor == null
                                    ? state._nullSizeFactorColumnsWidth
                                    : width * column.sizeFactor!,
                                child: Tooltip(
                                    message: column.title,
                                    child: MouseRegion(
                                      cursor: column.sortable
                                          ? SystemMouseCursors.click
                                          : SystemMouseCursors.basic,
                                      child: GestureDetector(
                                        onTap: column.sortable
                                            ? () {
                                                state.swapSortBy(column.id!);
                                              }
                                            : null,
                                        child: Row(
                                          mainAxisAlignment: column.isNumeric
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            if (state.isSorted &&
                                                state._sortBy!.columnId ==
                                                    column.id) ...[
                                              state._sortBy!._descending
                                                  ? const Icon(Icons
                                                      .arrow_downward_rounded)
                                                  : const Icon(Icons
                                                      .arrow_upward_rounded),
                                              const SizedBox(width: 8)
                                            ],
                                            Flexible(
                                                child: Text(column.title,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis))
                                          ],
                                        ),
                                      ),
                                    ))),
                          ))
                      .toList(),
                );
              }),

          /* LOADING INDICATOR */
          Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Selector<_PagedDataTableState<TKey, TResult>, _TableState>(
                  selector: (context, state) => state._state,
                  builder: (context, tableState, child) {
                    return AnimatedOpacity(
                        opacity: tableState == _TableState.loading ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const LinearProgressIndicator());
                  })),
        ],
      ),
    );
  }
}
