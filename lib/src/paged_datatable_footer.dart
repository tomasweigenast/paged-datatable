part of 'paged_datatable.dart';

class _PagedDataTableFooter<TKey extends Object, TResult extends Object> extends StatelessWidget {
  const _PagedDataTableFooter();

  @override
  Widget build(BuildContext context) {
    var state = context.read<_PagedDataTableState<TKey, TResult>>();

    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /* USER DEFINED CONTROLS */
      
            const Spacer(),
            
            /* PAGINATION CONTROLS */
            Row(
              children: [
                /* ROWS PER PAGE */
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Rows per page"),
                    const SizedBox(width: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 100
                      ),
                      child: DropdownButtonFormField<int>(
                        value: 100,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          border: OutlineInputBorder()
                        ),
                        style: const TextStyle(fontSize: 14),
                        onChanged: (newPageSize) {
                          if(newPageSize != null) {
                            state.setPageSize(newPageSize);
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: 10, child: Text("10")),
                          DropdownMenuItem(value: 20, child: Text("20")),
                          DropdownMenuItem(value: 50, child: Text("50")),
                          DropdownMenuItem(value: 100, child: Text("100")),
                        ],
                      ),
                    )
                  ],
                ),
            
                const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: VerticalDivider(indent: 10, endIndent: 10)),
                
                /* CURRENT PAGE ELEMENTS */
                Text("Showing ${state.currentItems.length} elements"),
            
                const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: VerticalDivider(indent: 10, endIndent: 10)),
            
                /* PAGE BUTTONS */
                IconButton(
                  tooltip: "Previous page",
                  splashRadius: 20,
                  icon: const Icon(Icons.keyboard_arrow_left_rounded),
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                IconButton(
                  tooltip: "Next page",
                  splashRadius: 20,
                  icon: const Icon(Icons.keyboard_arrow_right_rounded),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      )
    );
  }
}