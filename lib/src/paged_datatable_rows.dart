part of 'paged_datatable.dart';

class _PagedDataTableRows<TKey extends Comparable, TResultId extends Comparable,
    TResult extends Object> extends StatelessWidget {
  final WidgetBuilder? noItemsFoundBuilder;
  final ErrorBuilder? errorBuilder;
  final bool rowsSelectable;
  final double width;
  final CustomRowBuilder<TResult> customRowBuilder;

  const _PagedDataTableRows(this.rowsSelectable, this.customRowBuilder, this.noItemsFoundBuilder,
      this.errorBuilder, this.width);

  @override
  Widget build(BuildContext context) {
    final theme = PagedDataTableTheme.of(context);

    return Selector<_PagedDataTableState<TKey, TResultId, TResult>, int>(
      selector: (context, model) => model._rowsChange,
      builder: (context, _, child) {
        var state = context.read<_PagedDataTableState<TKey, TResultId, TResult>>();
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: state.tableState == _TableState.loading ? .3 : 1,
          child: DefaultTextStyle(
              overflow: TextOverflow.ellipsis,
              style: theme.rowsTextStyle,
              child: _build(context, state, theme)),
        );
      },
    );
  }

  Widget _build(BuildContext context, _PagedDataTableState<TKey, TResultId, TResult> state,
      PagedDataTableThemeData theme) {
    if (state._rowsState.isEmpty && state.tableState == _TableState.displaying) {
      return noItemsFoundBuilder?.call(context) ??
          Center(child: Text(PagedDataTableLocalization.of(context).noItemsFoundText));
    }

    if (state.tableState == _TableState.error) {
      return errorBuilder?.call(state.currentError!) ??
          Center(
              child: Text("An error ocurred.\n${state.currentError}", textAlign: TextAlign.center));
    }

    return ListView.separated(
        controller: state.rowsScrollController,
        separatorBuilder: (_, __) => theme.dividerColor == null
            ? const Divider(height: 0)
            : Divider(height: 0, color: theme.dividerColor),
        itemCount: state._rowsState.length,
        itemBuilder: (context, index) =>
            ChangeNotifierProvider<_PagedDataTableRowState<TResultId, TResult>>.value(
              value: state._rowsState[index],
              child: Consumer<_PagedDataTableRowState<TResultId, TResult>>(
                builder: (context, model, child) {
                  if (customRowBuilder.shouldUse(context, model.item)) {
                    return SizedBox(
                      height: theme.configuration.rowHeight,
                      child: customRowBuilder.builder(context, model.item),
                    );
                  }

                  Widget row = SizedBox(
                    height: 52,
                    child: Ink(
                      padding: EdgeInsets.zero,
                      color: model._isSelected ? Theme.of(context).primaryColorLight : null,
                      child: InkWell(
                        onTap: rowsSelectable ? () {} : null,
                        onDoubleTap: rowsSelectable
                            ? () {
                                final newState = !(state.selectedRows[model.itemId] ?? false);
                                state.selectedRows[model.itemId] = newState;
                                model.selected = newState;
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: state.columns
                              .map((column) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: SizedBox(
                                        width: column.sizeFactor == null
                                            ? state._nullSizeFactorColumnsWidth
                                            : width * column.sizeFactor!,
                                        child: Align(
                                          alignment: column.isNumeric
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          heightFactor: null,
                                          child: column.buildCell(model.item, model.index),
                                        )),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  );

                  if (theme.rowColors != null) {
                    row = DecoratedBox(
                      decoration: BoxDecoration(
                          color: index % 2 == 0 ? theme.rowColors![0] : theme.rowColors![1]),
                      child: row,
                    );
                  }

                  return row;
                },
              ),
            ));
  }
}
