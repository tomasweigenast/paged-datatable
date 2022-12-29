part of 'paged_datatable.dart';

class _PagedDataTableHeaderRow<TKey extends Object, TResult extends Object> extends StatelessWidget {
  const _PagedDataTableHeaderRow();

  @override
  Widget build(BuildContext context) {
    var state = context.read<_PagedDataTableState<TKey, TResult>>();

    return SizedBox(
      height: 56,
      child: Row(
        children: state.columns.map((column) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: (state.viewSize.width - (32 * state.columns.length)) * column.sizeFactor,
            child: Align(
              alignment: column.isNumeric ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(column.title, style: const TextStyle(fontWeight: FontWeight.bold))
            )
          ),
        )).toList(),
      ),
    );
  }
}