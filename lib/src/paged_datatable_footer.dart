part of 'paged_datatable.dart';

class _PagedDataTableFooter<TKey extends Object, TResult extends Object> extends StatelessWidget {
  final Widget? footer;
  
  const _PagedDataTableFooter(this.footer);

  @override
  Widget build(BuildContext context) {
    final config = PagedDataTableConfiguration.of(context);

    return Consumer<_PagedDataTableState<TKey, TResult>>(
      builder: (context, state, child) => SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /* USER DEFINED CONTROLS */
              if(footer != null)
                footer!,
    
              /* PAGINATION CONTROLS */
              Row(
                children: [
                  /* REFRESH */
                  if(state.refreshInterval != null)
                    ...[
                      _TimerBuilder(
                        builder: (context, isEnabled, call) => IconButton(
                          splashRadius: 20,
                          tooltip: "Refresh${state._lastRefreshAt != null ? '. Last refreshed ${timeago.format(state._lastRefreshAt!)}' : ''}",
                          onPressed: isEnabled ? () async {
                            await state._refresh();
                            call();
                          } : null, 
                          icon: const Icon(Icons.refresh_outlined)
                        ),
                        canDisplay: () => state._lastRefreshAt == null || state._lastRefreshAt!.add(state.refreshInterval!).isBefore(DateTime.now()),
                        checkInterval: state.refreshInterval!,
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: VerticalDivider(indent: 10, endIndent: 10)),
                    ],
    
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
                          onChanged: state.tableState == _TableState.loading ? null : (newPageSize) {
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
                  if(config.footer.showTotalElements)
                    Text("Showing ${state.tableCache.currentLength} elements")
                  else
                    Text("Page ${state.tableCache.currentPageIndex}"),
              
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: VerticalDivider(indent: 10, endIndent: 10)),
              
                  /* PAGE BUTTONS */
                  IconButton(
                    tooltip: "Previous page",
                    splashRadius: 20,
                    icon: const Icon(Icons.keyboard_arrow_left_rounded),
                    onPressed: (state.tableCache.canGoBack && state.tableState != _TableState.loading) ? () {
                      state.navigate(state.tableCache.currentPageIndex-1);
                    } : null,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    tooltip: "Next page",
                    splashRadius: 20,
                    icon: const Icon(Icons.keyboard_arrow_right_rounded),
                    onPressed: (state.tableCache.canGoNext && state.tableState != _TableState.loading) ? () {
                      state.navigate(state.tableCache.currentPageIndex+1);
                    } : null,
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}