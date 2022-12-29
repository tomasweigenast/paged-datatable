part of 'paged_datatable.dart';

class _PagedDataTableRows<TKey extends Object, TResult extends Object> extends StatelessWidget {
  const _PagedDataTableRows();

  @override
  Widget build(BuildContext context) {
    var state = context.read<_PagedDataTableState<TKey, TResult>>();

    return DefaultTextStyle(
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 14),
      child: ListView.separated(
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemCount: state.currentItems.length,
        itemBuilder: (context, index) => SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: state.columns.map((column) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: (state.viewSize.width - (32 * state.columns.length)) * column.sizeFactor,
                child: Align(
                  alignment: column.isNumeric ? Alignment.centerRight : Alignment.centerLeft,
                  child: column.itemBuilder(state.currentItems[index]),
                  heightFactor: null,
                )
              ),
            )).toList(),
          ),
        )
      ),
    );
  }
}