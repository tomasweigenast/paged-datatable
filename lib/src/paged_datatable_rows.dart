part of 'paged_datatable.dart';

class _PagedDataTableRows<TKey extends Object, TResult extends Object> extends StatelessWidget {
  final WidgetBuilder? noItemsFoundBuilder;
  final ErrorBuilder? errorBuilder;
  
  const _PagedDataTableRows(this.noItemsFoundBuilder, this.errorBuilder);

  @override
  Widget build(BuildContext context) {
    var state = context.read<_PagedDataTableState<TKey, TResult>>();

    return DefaultTextStyle(
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 14),
      child: _build(state)
    );
  }
  Widget _build(_PagedDataTableState<TKey, TResult> state) {
    if(state.tableCache.currentLength == 0 && state.tableState == _TableState.displaying) {
      return noItemsFoundBuilder?.call() ?? const Center(child: Text("No items found"));
    }

    if(state.tableState == _TableState.error) {
      return errorBuilder?.call(state.currentError!) ?? Center(child: Text("An error ocurred.\n${state.currentError}", textAlign: TextAlign.center));
    }

    return ListView.separated(
      controller: state.rowsScrollController,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemCount: state.tableCache.currentResultset.length,
      itemBuilder: (context, index) => SizedBox(
        height: 52,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: state.columns.map((column) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: state.viewportSize.width * column.sizeFactor,
              child: Align(
                alignment: column.isNumeric ? Alignment.centerRight : Alignment.centerLeft,
                child: column._buildCell(state.tableCache.currentResultset[index]),
                heightFactor: null,
              )
            ),
          )).toList(),
        ),
      )
    );
  }
}