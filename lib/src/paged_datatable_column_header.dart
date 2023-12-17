part of 'paged_datatable.dart';

class _PagedDataTableHeaderRow<
    TKey extends Comparable,
    TResultId extends Comparable,
    TResult extends Object> extends StatelessWidget {
  final bool rowsSelectable;
  final double width;

  const _PagedDataTableHeaderRow(this.rowsSelectable, this.width);

  @override
  Widget build(BuildContext context) {
    PagedDataTableThemeData theme = PagedDataTableTheme.of(context);
    Widget child = SizedBox(
      height: theme.configuration.columnsHeaderHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /* COLUMNS */
          Selector<_PagedDataTableState<TKey, TResultId, TResult>, int>(
            selector: (context, state) => state._sortChange,
            builder: (context, isSorted, child) {
              final state = context
                  .read<_PagedDataTableState<TKey, TResultId, TResult>>();
              return Row(
                children: [
                  if (rowsSelectable)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Selector<
                          _PagedDataTableState<TKey, TResultId, TResult>, int>(
                        selector: (context, model) =>
                            model._rowsSelectionChange,
                        builder: (context, value, child) {
                          return SizedBox(
                            width: width * .05,
                            child: HookBuilder(
                              builder: (context) {
                                return Checkbox(
                                  value: state.selectedRows.isEmpty
                                      ? false
                                      : state.selectedRows.length ==
                                              state._items.length
                                          ? true
                                          : null,
                                  tristate: true,
                                  onChanged: (newValue) {
                                    // currentValue.value = newValue;
                                    switch (newValue) {
                                      case true:
                                        state.selectAllRows();
                                        break;

                                      case false:
                                        state.unselectAllRows();
                                        break;

                                      case null:
                                        if (state.selectedRows.length ==
                                            state._items.length) {
                                          state.unselectAllRows();
                                        }
                                        break;
                                      default:
                                        state.unselectAllRows();
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ...state.columns.map(
                    (column) {
                      Widget child = MouseRegion(
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
                              if (state.hasSortModel &&
                                  state._sortModel!.columnId == column.id) ...[
                                state._sortModel!._descending
                                    ? const Icon(Icons.arrow_downward_rounded)
                                    : const Icon(Icons.arrow_upward_rounded),
                                const SizedBox(width: 8)
                              ],
                              Flexible(
                                child: column.title != null
                                    ? Text(
                                        column.title!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : column.titleBuilder!(context),
                              )
                            ],
                          ),
                        ),
                      );

                      if (column.title != null) {
                        child = Tooltip(message: column.title, child: child);
                      }

                      child = Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                            width: column.sizeFactor == null
                                ? state._nullSizeFactorColumnsWidth
                                : width * column.sizeFactor!,
                            child: child),
                      );
                      return child;
                    },
                  )
                ],
              );
            },
          ),

          /* LOADING INDICATOR */
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Selector<_PagedDataTableState<TKey, TResultId, TResult>,
                _TableState>(
              selector: (context, state) => state._state,
              builder: (context, tableState, child) {
                return AnimatedOpacity(
                  opacity: tableState == _TableState.loading ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const LinearProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );

    if (theme.headerBackgroundColor != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(color: theme.headerBackgroundColor),
        child: child,
      );
    }

    if (theme.headerTextStyle != null) {
      child = DefaultTextStyle(
        style: theme.headerTextStyle!,
        child: child,
      );
    }

    return child;
  }
}
