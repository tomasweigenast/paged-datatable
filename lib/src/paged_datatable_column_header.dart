part of 'paged_datatable.dart';

class _PagedDataTableHeaderRow<TKey extends Object, TResult extends Object> extends StatelessWidget {
  const _PagedDataTableHeaderRow();

  @override
  Widget build(BuildContext context) {
    var state = context.read<_PagedDataTableState<TKey, TResult>>();

    return SizedBox(
      height: 56,
      child: Stack(
        fit: StackFit.expand,
        children: [

          /* COLUMNS */
          Row(
            children: state.columns.map((column) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: (state.viewSize.width - (32 * state.columns.length)) * column.sizeFactor,
                child: Tooltip(
                  message: column.title,
                  child: MouseRegion(
                    cursor: column.sortable ? SystemMouseCursors.click : SystemMouseCursors.basic,
                    child: GestureDetector(
                      onTap: column.sortable ? () {
                        state.swapSortBy(column.id!);
                      } : null,
                      child: Row(
                        mainAxisAlignment: column.isNumeric ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if(state.isSorted && state._sortBy!.columnId == column.id)
                            state._sortBy!._descending ? const Icon(Icons.arrow_downward_rounded) : const Icon(Icons.arrow_upward_rounded),

                          Flexible(child: Text(column.title, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis))
                        ],
                      ),
                    ),
                  )
                )
              ),
            )).toList(),
          ),

          /* LOADING INDICATOR */
          Positioned(
            bottom: 0, 
            width: MediaQuery.of(context).size.width, 
            child: AnimatedOpacity(
              opacity: state.state == _TableState.loading ? 1 : 0, 
              duration: const Duration(milliseconds: 300),
              child: const LinearProgressIndicator()
            )
          ),
        ],
      ),
    );
  }
}